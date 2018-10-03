% Calculate performance indes based on turning events
function calcPIturn(obj)
    yDivide = obj.yDivide;
    expPhase = cat(1,obj.Frames.ExpPhase);
    trialFrameNum = obj.FrameRate * obj.TrialDuration;
    head = cat(1,obj.Frames.Head);
    tail = cat(1,obj.Frames.Tail);
    H2T = head - tail;
    H2T = sqrt(H2T(:,1).^2+H2T(:,2).^2);
    idxNan = find(head == -1);
    head(idxNan) = nan;
    patternIdx = cat(1,obj.Frames.PatternIdx);
    HA = cat(1,obj.Frames.HeadingAngle);
    AC = calcCirAngleChange(HA);
    ACthre = 15; % degrees, angle change threshold
    bodyLength = obj.calcFishLen();
    boundWidth = 30; % to eliminate the influence of boundary effect
    % xLimits = [min(head(:,1))+boundWidth,max(head(:,1))-boundWidth];
    trialIdx = 0;
    % Baseline - Training - Blackout - Test
    for n = 1:4
        if n == 1
            obj.Res.PIturn(n).Phase = 'Baseline';
        elseif n == 2
            obj.Res.PIturn(n).Phase = 'Training';
        elseif n == 3
            obj.Res.PIturn(n).Phase = 'Blackout';
            obj.Res.PIturn(n).PIfish = [];
            trialIdx = trialIdx + 1 * 60 / obj.TrialDuration ; % the 0.5 means blackout
            continue;
        elseif n == 4
            obj.Res.PIturn(n).Phase = 'Test';
        end
        
        idx = find(expPhase == n - 1);
        idx(end) = []; % delete the last frame to avoid inaligned error
        tempPattern = patternIdx(idx);
        tempHA = HA(idx);
        tempAC = AC(idx);
        tempHead = head(idx,:);
        tempH2T = H2T(idx);
        
        imThre = 155; % it is impossible to turn 120 degrees between two frames
        
        L = (abs(tempAC) > ACthre) & (abs(tempAC) < imThre)...
            & (tempH2T > 0.8 * bodyLength/2);
        idxT = find(L);
        if ~isempty(idxT)
            if (idxT(end) == length(idx))
                postIdx = min(idxT(end) + 1,length(HA));
                lastPostAngle = HA(postIdx);
                postAngles = [tempHA(idxT(1:end-1)+1);lastPostAngle];
            else
                postAngles = tempHA(idxT+1);
            end
            % turnMat: n*7 matrix: each row is consisted of
            % turnTiming, preAngle, postAngle, angleChange, headPosition(Y), patternIdx, score
            turnMat = cat(2,idx(idxT),tempHA(idxT),postAngles,tempAC(idxT),...
                tempHead(idxT,2),tempPattern(idxT),zeros(size(idxT)));
            
            turnMat = calc_score_for_turn(turnMat,ACthre,yDivide,bodyLength);
            % eliminate 0 score turns
            idx1 = find(turnMat(:,7));
            turnMat = turnMat(idx1,:);
            
            
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
        
        
        trialNum = round(length(idx)/trialFrameNum);
        obj.Res.PIturn(n).Trial = zeros(trialNum,1);
        for j = 1:trialNum
            lower = trialIdx * trialFrameNum + (j-1)*trialFrameNum + 1;
            if(j~=trialNum) 
                upper = trialIdx * trialFrameNum + j * trialFrameNum;
            else
                upper = trialIdx * trialFrameNum + length(idx);
            end
            scoresTrial = obj.Res.PIturn(n).Scores(find(obj.Res.PIturn(n).TurnTiming>lower & obj.Res.PIturn(n).TurnTiming<=upper));
            obj.Res.PIturn(n).Trial(j) = (sum(scoresTrial)/sum((scoresTrial)~=0) + 1) / 2;
        end
        trialIdx = trialNum + trialIdx;
    end
    obj.Res.PIincreTurn = obj.Res.PIturn(4).PIfish - obj.Res.PIturn(1).PIfish;
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
    % +1 case, turn around at the mid-line when fish is in non-CS Area
    if (aPre < 0)
        if (y > 0) && (y < 2 * fishLen) % valid range
            preInterAngle = abs(aPre + 90); % angle to the normal line
            postInterAngle = abs(aPost + 90);
            interAngleChange = postInterAngle - preInterAngle;
            if interAngleChange > ACthre
                turnMat(i,7) = 1;
            end
        end
    % -1 case, turn around at the mid-line when fish is in CS Area
    elseif (aPre > 0) 
        if (y < 0) && (y > -2 * fishLen) % valid range
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

