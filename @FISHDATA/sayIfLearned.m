% Measure whether fish learned or not
% By dividing the entire process into trials (2 mins as a trial)
% measure fish performance in each trial, to decide whether fish learned or
% not and measure the memory extinction
% TODO: Modularize code
% Caution: not correct, do not use
function [h, p, extincTime] = sayIfLearned(obj)
  obj.ratePerformance();
  Baseline_trial = obj.Res.PItime(1).Trial;
  Test_trial = obj.Res.PItime(4).Trial;
  BasePI = obj.Res.PItime(1).PIfish;
  idx=find(Test_trial<BasePI,1);
  if(isempty(idx))
      idx = length(Test_trial) + 1;
  end
  num_trial=idx-1;
  if num_trial<2
       extincTime=[];
       h = 0;
       p = nan;
  else
     extincTime = num_trial*120;  % seconds
    [h,p] = ttest2(Baseline_trial,Test_trial(1:num_trial));
  end 
    obj.Res.ExtinctTime = extincTime;
    obj.Res.IfLearned = h;

end
