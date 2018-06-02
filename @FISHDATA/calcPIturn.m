% Calculate performance indes based on turning events
function calcPIturn(obj)
    yDivide = obj.yDivide;
    expPhase = cat(1,obj.Frames.ExpPhase);
    head = cat(1,obj.Frames.Head);
    patternIdx = cat(1,obj.Frames.PatternIdx);
    HA = cat(1,obj.Frames.HeadingAngle);
    AC = calcCirAngleChange(HA);
    ACthre = 20; % degrees, angle change threshold
    bodyLength = obj.calcFishLen();
    
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

