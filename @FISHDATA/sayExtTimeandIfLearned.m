% Measure the memory of fish of the learned association
% As I know, there are at least 2 kinds of memory: retention and extinction
% 1. when the CS pattern continues to show on but without electric shock
% the fish may un-learn the association.
% 2. after the fish learned, put them in normal raising house for a while,
% then test whether they will show escaping responses to CS pattern.
% In this experiment, we measured the first kind of memory

% TODO: rewrite this function to find the extinction point

function [extTime,num_trail,Test_trail,meanBT] = sayExtTimeandIfLearned(obj)
  Baseline_trail=measure_trail(obj,1);
  Test_trail=measure_trail(obj,4);
  meanBT=mean(Baseline_trail);
   num_trail = 1;
   while Test_trail(num_trail)>meanBT
       num_trail = num_trail + 1;
   end
     num_trail=num_trail-1;
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

function Trail=measure_trail(obj,m)
  % m means we want to get PITime(m)'s trails
  if m==1
    trail_num=5;
  elseif m==4
    trail_num=9;
  end
  Interval = 120; % seconds
  frameRate = obj.FrameRate;
  windowWidth = Interval * frameRate;
  begin_idx=1;
  end_idx=windowWidth;
for i=1:trail_num-1
   Trail(i)=mean(obj.Res.PItime(m).Scores(begin_idx:end_idx));
   begin_idx= end_idx+1;
   end_idx= end_idx+ windowWidth;
end
  Trail(trail_num)=mean(obj.Res.PItime(m).Scores(begin_idx:end));
  % PITime sometimes lacks of one or two frames
end
