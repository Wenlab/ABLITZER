%  Filename: plotDist2centerline.m (method of FISHDATA class)
%  Abstract:
%        Plot distance to centerline of the arena for a FISHDATA.
%
%   SYNTAX:
%       1. obj.plotDist2centerline(phase)
%       2. plotDist2centerline(obj,phase)
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
    phase)   % 0: Entire experimental phases;  1:Baseline; 2:Training 4:Test
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
    if phase==0
       plotFigure(1,29399,y,shockTiming,ExtinctTime,frameRate,phase)     % new data: 29399->29400
     elseif phase==1
       plotFigure(1,6000,y,shockTiming,ExtinctTime,frameRate,phase)
     elseif phase==2
       plotFigure(6001,18000,y,shockTiming,ExtinctTime,frameRate,phase)
     elseif phase==4 
       plotFigure(18600,29399,y,shockTiming,ExtinctTime,frameRate,phase)   % new data: 29399->29400
    end
end
function plotFigure(numFrame1,numFrame2,y,shockTiming,ExtinctTime,frameRate,phase)
    figure;
    if phase==2
        scatter(shockTiming, 14*ones(size(shockTiming)),8,'r.');
        hold on;
        xlim([10,30]);
    elseif phase==4 
        scatter(ExtinctTime,0,'b');
         hold on;
        xlim([31,49]);
    end
    if phase==0
      X1 = [0 0 5 5];
      X2 = [30 30 31 31];
      Y = [-15 15 15 -15];
      fill(X1,Y,[0.9,0.9,0.9],'EdgeColor','none');
      hold on;
      fill(X2,Y,[0.9,0.9,0.9],'EdgeColor','none');
      scatter(shockTiming, 14*ones(size(shockTiming)),8,'r.');
      scatter(ExtinctTime,0,'b');
      xlim([0,50]);
    end
    t = (numFrame1:numFrame2 )/ frameRate / 60; % convert it to mins
    scatter(t,y(numFrame1:numFrame2),8,'k.');
    ylim([-15,15]);
    
    xlabel('Time (min)');
    ylabel('Distance to centerline (mm)');
  
end
