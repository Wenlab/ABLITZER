function Trial=measure_trial(obj,m)
  % m means we want to get PITime(m)'s trails
  if m==1
    trial_num=5;
  elseif m==2
    trial_num=10;
  elseif m==4
    trial_num=9;
  end
  Interval = 120; % seconds
  frameRate = obj.FrameRate;
  windowWidth = Interval * frameRate;
  begin_idx=1;
  end_idx=windowWidth;
for i=1:trial_num-1
   Trial(i)=length(find(obj.Res.PItime(m).Scores(begin_idx:end_idx)) == 1)...
          / length(find(obj.Res.PItime(m).Scores(begin_idx:end_idx)) ~= 0);
   begin_idx= end_idx+1;
   end_idx= end_idx+ windowWidth;
end
  Trial(trial_num) = length(find(obj.Res.PItime(m).Scores(begin_idx:end)) == 1)...
                   / length(find(obj.Res.PItime(m).Scores(begin_idx:end)) ~= 0);

  % PITime sometimes lacks of one or two frames
end
