% Rate fish performance in the task
function ratePerformance(obj)
    evaluateDataQuality(obj);
    calc_PI_by_time(obj);
    calc_PI_by_turn(obj);
    calc_PI_by_shock(obj);
    %plot_PI_versus_time(obj);
end

% Calculate performance index by time spent on each side.
% ExpPhase can indicate which phase the current frame is in
function calc_PI_by_time(obj)
    yDivide = obj.yDivide;
    expPhase = cat(1,obj.Frames.ExpPhase);
    head = cat(1,obj.Frames.Head);
    patternIdx = cat(1,obj.Frames.PatternIdx);
    
    % Baseline - Training - Blackout - Test
    for n = 1:4
        if n == 1
            obj.Res.PItime(n).Phase = 'Baseline';
        elseif n == 2
            obj.Res.PItime(n).Phase = 'Training';
        elseif n == 3
            obj.Res.PItime(n).Phase = 'Blackout';
            continue; % since blackout does not show CS pattern
        elseif n == 4
            obj.Res.PItime(n).Phase = 'Test';
        end
        
        idx = find(expPhase == n - 1);
        tempPattern = patternIdx(idx);
        tempHead = head(idx,2);
        idxNaN = find(tempHead == -1);
        scores = zeros(length(idx),1);
         
        % when the fish is in NCS, give him a point, otherwise no point
        for i = 1:length(idx)
            if tempPattern(i) == 0 % CS on the top
                scores(i) = 2*(tempHead(i) > yDivide) - 1;
            elseif tempPattern(i) == 1 % CS on the bottom
                scores(i) = 2*(tempHead(i) < yDivide) - 1;
            elseif tempPattern(i) == 2 % blackout
                scores(i) = 0; 
            end
        end
        scores(idxNaN) = 0; % exclude the impact of invalid points
        obj.Res.PItime(n).Scores = scores;
        % PItime is defined as the percent of time fish spent in NCS area,
        % which excludes the unrecognized frames and blackout frames
        obj.Res.PItime(n).PIfish = length(find(scores==1)) / length(find(scores~=0));  
    end

end

% Calculate performance index by time spent on each side.
% ExpPhase can indicate which phase the current frame is in
% TODO: Test the effect of this function and improve it. 
function calc_PI_by_turn(obj)
    yDivide = obj.yDivide;
    expPhase = cat(1,obj.Frames.ExpPhase);
    head = cat(1,obj.Frames.Head);
    patternIdx = cat(1,obj.Frames.PatternIdx);
    HA = cat(1,obj.Frames.HeadingAngle);
    AC = calcCirAngleChange(HA);
    ACthre = 30; % degrees, angle change threshold
    height = obj.ConfinedRect(4);
    yTopBound = yDivide - height / 5;
    yBottomBound = yDivide + height / 5;
    
    % Baseline - Training - Blackout - Test
    for n = 1:4
        if n == 1
            obj.Res.PIturn(n).Phase = 'Baseline';
        elseif n == 2
            obj.Res.PIturn(n).Phase = 'Training';
        elseif n == 3
            obj.Res.PIturn(n).Phase = 'Blackout';
            obj.Res.PIturn(n).PIfish = [];
            continue;
        elseif n == 4
            obj.Res.PIturn(n).Phase = 'Test';
        end
        idx = find(expPhase == n - 1);
        idx(end) = []; % delete the last frame to avoid inaligned error
        tempPattern = patternIdx(idx);
        tempHA = HA(idx);
        tempAC = AC(idx);
        tempHeadY = head(idx,2);
        turnMat = [];
        for i = 1:length(idx)
            if abs(tempAC(i)) > ACthre % it's a turn
                % turnMat: n*7 matrix: each row is consisted of
                % turnTiming, preAngle, postAngle, angleChange,
                % headPosition(Y), patternIdx, score
                if i == length(idx)           
                    postIdx = min(idx(i)+1,length(HA));
                    postHA = HA(postIdx);    
                else
                    postHA = tempHA(i+1);
                end
                turnMat = cat(1,turnMat,[idx(i),tempHA(i),postHA,...
                        tempAC(i),tempHeadY(i),tempPattern(i),0]);
            end          
        end
        if ~isempty(turnMat)
            turnMat = calc_score_for_turn(turnMat,yTopBound,yBottomBound);
            obj.Res.PIturn(n).TurnTiming = turnMat(:,1);
            obj.Res.PIturn(n).PreAngle = turnMat(:,2);
            obj.Res.PIturn(n).PostAngle = turnMat(:,3);
            obj.Res.PIturn(n).AngleChange = turnMat(:,4);
            obj.Res.PIturn(n).TurnPos = turnMat(:,5);
            obj.Res.PIturn(n).PatternIdx = turnMat(:,6);
            obj.Res.PIturn(n).Scores = turnMat(:,7);
            obj.Res.PIturn(n).PIfish = sum(turnMat(:,7))/size(turnMat,1);
        end    
    end


end

function angleDiff = calcCirAngleChange(angleArray)
    angleDiff = diff(angleArray);
    for i=1:length(angleDiff)
        angleChange = angleDiff(i);
        if abs(angleChange) > 180
            angleDiff(i) = sign(angleChange)*(360-abs(angleChange));
        end
    end
end

% Calculate the score for each turn, based on the head position,
% postAngle and patternIdx
% For example, when the CS stimulus is on the top,
% if the fish turn back to the CS area (e.g. turn from 90 deg to 0 deg),
% scores 1, if the fish turn to the CS area, scores -1 (e.g. from 0 deg to
% 9 deg), other cases (e.g. turn from 90 deg to 120 deg), scores 0
function turnMat = calc_score_for_turn(turnMat,yTopBound,yBottomBound)
for i=1:size(turnMat,1)
    turnData = turnMat(i,:);
    if (turnData(5) < yBottomBound)&&(turnData(5) > yTopBound)
        if turnData(6) == 0 % visual pattern on the top
            interAnglePre = min(360-abs(turnData(2)+90),abs(turnData(2)+90));
            interAnglePost = min(360-abs(turnData(3)+90),abs(turnData(3)+90));
        elseif turnData(6) == 1 % visual pattern on the bottom
            interAnglePre = min(360-abs(turnData(2)-90),abs(turnData(2)-90));
            interAnglePost = min(360-abs(turnData(3)-90),abs(turnData(3)-90));
        else % blackout
            continue;
        end
    else
        continue;
    end
    interAngleChange = interAnglePost - interAnglePre;
    if interAngleChange > 15
        turnMat(i,7) = 1;
    elseif interAngleChange < -15
        turnMat(i,7) = -1;
    else
        turnMat(i,7) = 0;
    end
end




end

% Calculate performance index by shock the fish received.
function calc_PI_by_shock(obj)
    expPhase = cat(1,obj.Frames.ExpPhase);
    shockOn = cat(1,obj.Frames.ShockOn);
    idx = find(expPhase == 1);
    tempShock = shockOn(idx);
    obj.Res.PIshock.Phase = 'Training';
    obj.Res.PIshock.ShockTiming = find(tempShock);
    obj.Res.PIshock.NumShocks = length(obj.Res.PIshock.ShockTiming);
    % ever received shock, give a minus credit
    obj.Res.PIshock.Scores = -1*tempShock;  
    obj.Res.PIshock.PIfish = sum(obj.Res.PIshock.Scores) / length(idx);
end



% Since the abnormal abrupt change of head positions is a sign of bad
% points, so the percent of bad points can be used as a metric to evaluate
% the data quality for each fish. 
% TODO?: replace the 2nd term in numBadPts by recorded framesUnmoved in yaml
function evaluateDataQuality(obj)
    % Constant Parameters
    distThre = 100;
    
    head = cat(1,obj.Frames.Head);
    headDiff = diff(head);
    headChange = sqrt(headDiff(:,1).^2 + headDiff(:,2).^2);
    % the second term measures frames fish unmoved for at least 1
    % seconds
    numBadPts = length(find(headChange > distThre))...
        + length(find(smooth(headChange,10) == 0));
    
    obj.Res.DataQuality = 1 - numBadPts/length(head);
end