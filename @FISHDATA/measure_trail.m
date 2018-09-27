function Trail=measure_trail(obj,m)
  % m means we want to get PITime(m)'s trails
  if m==1
    trail_num=5;
  elseif m==2
    trail_num=10;
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
  Trail = (Trail+1)/2;

  % PITime sometimes lacks of one or two frames
end
