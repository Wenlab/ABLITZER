% Measure the memory of fish of the learned association
% As I know, there are at least 2 kinds of memory: retention and extinction
% 1. when the CS pattern continues to show on but without electric shock
% the fish may un-learn the association.
% 2. after the fish learned, put them in normal raising house for a while,
% then test whether they will show escaping responses to CS pattern.
% In this experiment, we measured the first kind of memory

% TODO: rewrite this function to find the extinction point

function [extTime,num_trail,Test_trail,meanBT] = sayExtTimeandIfLearned(obj)
  obj.ratePerformance();
  Baseline_trail=measure_trail(obj,1);
  Test_trail=measure_trail(obj,4);
  meanBT=mean(Baseline_trail);
  idx=find(Test_trail>meanBT);
  a1=isempty(find(idx==1));
  a2=isempty(find(idx==2));
  a3=isempty(find(idx==3));
  a4=isempty(find(idx==4));
  a5=isempty(find(idx==5));
  if a1==1
     num_trail=0 ;
  elseif a2==1
      num_trail=1;
      elseif a3==1
      num_trail=2;
      elseif a4==1
      num_trail=3;
      elseif a5==1
      num_trail=4;
  else
      num_trail=5;
  end
  if num_trail<3
       extTime=[];
       h = 0;
       p = nan;
     else
     extTime = num_trail*120;  % seconds
    [h,p] = ttest2(Baseline_trail,Test_trail);
   end
    obj.Res.ExtinctTime = extTime;
     obj.Res.IfLearned = h;
end
