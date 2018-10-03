% Calculate performance index by shocks received.
function calcPIshock(obj)
    trialFrameNum = obj.FrameRate * obj.TrialDuration;
    expPhase = cat(1,obj.Frames.ExpPhase);
    shockOn = cat(1,obj.Frames.ShockOn);
    idx = find(expPhase == 1);   %training
    heads = cat(1,obj.Frames(idx).Head);
    tempShock = shockOn(idx);
    obj.Res.PIshock.Phase = 'Training';
    obj.Res.PIshock.ShockTiming = find(tempShock);
    shockPos = heads(obj.Res.PIshock.ShockTiming,:);
    obj.Res.PIshock.ShockPos = shockPos;
    numShocks = length(obj.Res.PIshock.ShockTiming);
    obj.Res.PIshock.NumShocks = numShocks;
    % calculate performance index based on paneltied shocks
    % calculate distance to centerline
    pIdx = cat(1,obj.Frames(idx).PatternIdx);
    pIdx = pIdx(obj.Res.PIshock.ShockTiming);
    y2CL = zeros(numShocks,1);
    yDiv = obj.yDivide;
    for i=1:numShocks
        if (pIdx(i) == 0) % CS on the top
            y2CL(i) = shockPos(i,2) - yDiv;
        elseif (pIdx(i) == 1) % CS on the top
            y2CL(i) = yDiv - shockPos(i,2);
        else % blackout
            continue;
        end  
    end
    obj.Res.PIshock.Scores = 1 + y2CL / max(abs(y2CL));  
    obj.Res.PIshock.PIfish = mean(obj.Res.PIshock.Scores);
    
    trialNum = round(length(idx)/trialFrameNum);
    obj.Res.PIshock.Trial = zeros(trialNum,1);
    for j = 1:trialNum
        lower = (j-1)*trialFrameNum + 1;
        if(j~=trialNum) 
            upper = j * trialFrameNum;
        else
            upper = length(idx);
        end
        scoresTrial = obj.Res.PIshock.Scores(find(obj.Res.PIshock.ShockTiming>lower ...
                                                  & obj.Res.PIshock.ShockTiming<=upper));
        obj.Res.PIshock.Trial(j) = mean(scoresTrial);
    end
    
    
end