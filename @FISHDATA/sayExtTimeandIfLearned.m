% Measure the memory of fish of the learned association
% As I know, there are at least 2 kinds of memory: retention and extinction
% 1. when the CS pattern continues to show on but without electric shock
% the fish may un-learn the association.
% 2. after the fish learned, put them in normal raising house for a while,
% then test whether they will show escaping responses to CS pattern.
% In this experiment, we measured the first kind of memory

% TODO: rewrite this function to find the extinction point

function [extTime,num_trial,Test_trial,meanBT] = sayExtTimeandIfLearned(obj)
  obj.ratePerformance();
  % Baseline_trail=measure_trial(obj,1);
  % Test_trail=measure_trial(obj,4);
  Baseline_trial = obj.Res.PItime(1).Trial;
  Test_trial = obj.Res.PItime(4).Trial;
  meanBT=mean(Baseline_trial);
  idx=find(Test_trial<meanBT,1);
  num_trial=idx-1;
  if num_trial<2
       extTime=[];
       h = 0;
       p = nan;
  else
     extTime = num_trial*120;  % seconds
    [h,p] = ttest2(Baseline_trial,Test_trial(1:num_trial));
  end 
    obj.Res.ExtinctTime = extTime;
    obj.Res.IfLearned = h;
end
