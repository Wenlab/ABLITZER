% Calculate performance index based on time spent on non-CS area
function calcPItime(obj)
    yDivide = obj.yDivide;
    expPhase = cat(1,obj.Frames.ExpPhase);
    head = cat(1,obj.Frames.Head);
    patternIdx = cat(1,obj.Frames.PatternIdx);
    trialFrameNum = obj.FrameRate * obj.TrialDuration;
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
        
        trialNum = round(length(idx)/trialFrameNum);
        obj.Res.PItime(n).Trial = zeros(trialNum,1);
        for j = 1:trialNum
            start = (j-1)*trialFrameNum + 1;
            if(j~=trialNum) 
                scoresTrial = scores(start:j * trialFrameNum);
            else
                scoresTrial = scores(start:end);
            end
            obj.Res.PItime(n).Trial(j) = length(find(scoresTrial==1)) / length(find(scoresTrial~=0));
        end
    end
    obj.Res.PIincreTime = obj.Res.PItime(4).PIfish - obj.Res.PItime(1).PIfish;

end