% Measure whether fish is self-abused not
% By dividing the entire process into trials (2 mins as a trial)
% measure fish performance in each trial, to decide whether fish learned or
% not and measure the memory extinction  
function [h, p] = sayIfSelfAbused(obj,metric,plotFlag)
    TrRes = obj.ratePerformanceByTrials(plotFlag);
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
    [h,p] = ttest2(preTrain,postTrain);
    if h == 1
        if mean(preTrain) > mean(postTrain)
            h = 1;
        else
            h = 0;
        end
    end
   
        
end