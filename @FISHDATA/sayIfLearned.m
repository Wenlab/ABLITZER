% Measure whether fish learned or not
% By dividing the entire process into trials (2 mins as a trial)
% measure fish performance in each trial, to decide whether fish learned or
% not and measure the memory extinction
% TODO: Modularize code
% Caution: not correct, do not use
function [h, p, extincTime] = sayIfLearned(obj,metric,plotFlag)
    TrRes = obj.ratePerformanceByTrials(metric, plotFlag);
    if contains(metric,'time','IgnoreCase',true) % normally used
        idxMetric = 1;
    elseif contains(metric,'turn','IgnoreCase',true)
        idxMetric = 2;
    elseif contains(metric,'maxCSstayTime','IgnoreCase',true)
        idxMetric = 3;
    elseif contains(metric,'dist2centerline','IgnoreCase',true)
        idxMetric = 4;
    else
        fprintf('Unrecognized metric, please choose one metric from the following:\n');
        fprintf('"time", "turn", "maxCSstayTime", "dist2centerline"');
        return;
    end
    preTrain = TrRes(1:5,idxMetric);
    postTrain = TrRes(end-8:end,idxMetric);

    idx = find(postTrain < mean(preTrain),1);
    if isempty(idx)
        [h,p] = ttest2(preTrain,postTrain);
    elseif idx <= 2 % at least one switch
        h = 0;
        p = nan;
    else
        [h,p] = ttest2(preTrain,postTrain(1:idx-1));
    end

    if h
        if isempty(idx)
            extincTime = inf;
        else
            extincTime = (idx - 1) * 2 * 60; % seconds
        end
    else
        extincTime = nan;
    end

    obj.Res.IfLearned = h;

end
