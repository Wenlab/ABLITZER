% Rate fish performance in the task
function ratePerformance(obj)
    evaluateDataQuality(obj);
    calc_PI_by_time(obj);
    calc_PI_by_turn(obj);
    calc_PI_by_shock(obj);
    %plot_PI_versus_time(obj);
end

% Calculate fish body length by measuring average length between fish tail
% and head
function bodyLength = calc_fish_bodyLength(obj)
    head = cat(1,obj.Frames.Head);
    tail = cat(1,obj.Frames.Tail);
    T2H = head - tail;
    bodyLens = sqrt(T2H(:,1).^2+T2H(:,2).^2);
    bodyLength = mean(bodyLens);
    if strcmp(obj.Strain,"GCaMP") % since a portion of fish tail is invisible
        bodyLength = bodyLength * 2;
    end
    
    
    obj.Res.BodyLength = bodyLength;

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
    ACthre = 20; % degrees, angle change threshold
    bodyLength = calc_fish_bodyLength(obj);
    
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
        imThre = 120; % it is impossible to turn 120 degrees between two frames
        for i = 1:length(idx)
            if (abs(tempAC(i)) > ACthre) && (abs(tempAC(i)) < imThre) % it's a turn         
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
            turnMat = calc_score_for_turn(turnMat,ACthre,yDivide,bodyLength);
            obj.Res.PIturn(n).TurnTiming = turnMat(:,1);
            obj.Res.PIturn(n).PreAngle = turnMat(:,2);
            obj.Res.PIturn(n).PostAngle = turnMat(:,3);
            obj.Res.PIturn(n).AngleChange = turnMat(:,4);
            obj.Res.PIturn(n).TurnPos = turnMat(:,5);
            obj.Res.PIturn(n).PatternIdx = turnMat(:,6);
            obj.Res.PIturn(n).Scores = turnMat(:,7);
            PIfish = sum(turnMat(:,7))/sum(turnMat(:,7)~=0);
            obj.Res.PIturn(n).PIfish = (PIfish + 1) / 2; % map to [0,1]
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
function turnMat = calc_score_for_turn(turnMat,ACthre,yDivide,fishLen)
for i=1:size(turnMat,1)
    
    turnData = turnMat(i,:);
    preAngle = turnData(2);
    postAngle = turnData(3);
    turnPos = turnData(5);
    pIdx = turnData(6);
    if (pIdx == 0) % CS area on the top
        pSign = 1;
    elseif (pIdx == 1) % CS area on the bottom
        pSign = -1;
    else % blackout
        continue;
    end
    % transform Descartes coordinates into NCS Area oriented coordinates
    % with center line as x axis
    y = (turnPos - yDivide) * pSign;
    aPre = preAngle * pSign;
    aPost = postAngle * pSign;
    % +1 case, turn around at the boundary when fish is in non-CS Area
    if (aPre < 0)
        if (y > 0) && (y < 1.5 * fishLen) % valid range
            preInterAngle = abs(aPre + 90); % angle to the normal line
            postInterAngle = abs(aPost + 90);
            interAngleChange = postInterAngle - preInterAngle;
            if interAngleChange > ACthre
                turnMat(i,7) = 1;
            end
        end
    % -1 case, turn around at the boundary when fish is in CS Area
    elseif (aPre > 0) 
        if (y < 0) && (y > -1.5 * fishLen) % valid range
            preInterAngle = abs(aPre - 90); % angle to the normal line
            postInterAngle = abs(aPost - 90);
            interAngleChange = postInterAngle - preInterAngle;
            if interAngleChange > ACthre
                turnMat(i,7) = -1;
            end
        end
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


function plot_time_proportion_over_time(scores)
    validCnt = scores ~= 0;
    idxNeg = find(scores == -1);
    scores(idxNeg) = 0;
    cumS = cumsum(scores);
    cumValidCnt = cumsum(validCnt);
    p = cumS ./ cumValidCnt;
    plot(p);


end