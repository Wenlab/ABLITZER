%  Filename: plotDist2centerline.m (method of FISHDATA class)
%  Abstract:
%        Plot distance to centerline of the arena for a FISHDATA.
%
%   SYNTAX:
%       1. obj.plotDist2centerline(phase,mark)
%       2. plotDist2centerline(obj,phase,mark)
%
% - plotDistance2centerline:
%      - FISHDATA method
%      - arg1: the entire process / test-phase only / baseline-phase / training-phase
%      - arg2: pixelSize
%      - arg3: w/o extinction point (blue triangle)
%      - arg4: w/o shocking events (red filled-circles)
%      - arg5: w/o shadows to demarcate consecutive phases
% TODO: Pixels converted to mm may still have problems.
%       When use new data, Change 29399 to 29400(the last frame num)
function plotDist2centerline(obj,...FISHDATA object
    phase,...  % 0: Entire experimental phases;  1:Baseline; 2:Training 4:Test
    mark)  % mark is a matrix of any combination of "shadows","shock" and "extinction point" 
    frameRate = obj.FrameRate;
    height = obj.ConfinedRect(4);
    yDiv = obj.yDivide;
    pIdx = cat(1,obj.Frames.PatternIdx);
    heads = cat(1,obj.Frames.Head);
    numFrames = length(pIdx);
    y2CL = zeros(numFrames,1);% distance (in y) to center line
    for i=1:numFrames
        if pIdx(i) == 0
            y2CL(i) = heads(i,2) - yDiv;
        elseif pIdx(i) == 1
            y2CL(i) = yDiv - heads(i,2);
        end
    end

    idx = abs(y2CL) > 200;
    y2CL(idx) = nan;
    y = (y2CL./(height/2)).*15;
    shockTiming = obj.Res.PIshock.ShockTiming / frameRate / 60 + 10;
    ExtinctTime = obj.Res.ExtinctTime/60+31;
    frameNum = [1,29399;1,6000;6001,18000;18001,18600;18601,29399];       % new data: 29399->29400
    plotFigure(frameNum(phase+1,:),y,shockTiming,ExtinctTime,frameRate,phase,mark);
   
end
function plotFigure(numFrame,y,shockTiming,ExtinctTime,frameRate,phase,s2)
    figure;
    s1 = ["shadows","shock","extinction point"];
    if length(s2)==3
        idx=[1,2,3];
    elseif length(s2)==2
      flag1 = strcmpi(s1,s2(1));  
      flag2 = strcmpi(s1,s2(2)); 
      idx(1)= find(flag1==1);
      idx(2)= find(flag2==1);
    else
      flag = strcmpi(s1,s2);
      idx = find(flag==1);
    end
    if ~isempty(find(idx==1))
      X1 = [0 0 10 10];
      X2 = [30 30 31 31];
      Y = [-15 15 15 -15];
      fill(X1,Y,[0.9,0.9,0.9],'EdgeColor','none');
      hold on;
      fill(X2,Y,[0.9,0.9,0.9],'EdgeColor','none');
    end
     if ~isempty(find(idx==2))
        scatter(shockTiming, 14*ones(size(shockTiming)),8,'r.');
        hold on;
     end  
      if ~isempty(find(idx==3))
         if ~isempty(ExtinctTime)
            scatter(ExtinctTime,0,'b');
             hold on;
         end
     end  
    xlimNum = [ 0,50;0,10;10,30;30,31;31,49];
    xlim(xlimNum(phase+1,:));
    t = (numFrame(1):numFrame(2) )/ frameRate / 60; % convert it to mins
    scatter(t,y(numFrame(1):numFrame(2)),8,'k.');
    ylim([-15,15]);
    xlabel('Time (min)');
    ylabel('Distance to centerline (mm)');

end
