%  Filename: plotDist2centerline.m (method of FISHDATA class)
%  Abstract:
%        Plot distance to centerline of the arena for a FISHDATA.
%
%   SYNTAX:
%       1. obj.plotDist2centerline(phase,key1,value1,...)
%       2. plotDist2centerline(obj,phase,key1,value1,...)
%
% - plotDistance2centerline:
%      - FISHDATA method
%      - arg1: the entire process / test-phase only / baseline-phase / training-phase
%      - arg2: w/o extinction point (blue triangle)
%      - arg3: w/o shocking events (red filled-circles)
%      - arg4: w/o shadows to demarcate consecutive phases, only shows up with the
%      entire process
% TODO: Pixels converted to mm may still have problems.
%       When use new data, Change 29399 to 29400(the last frame num)
function plotDist2centerline(obj,...FISHDATA object
    phase,...  % 0: Entire experimental phases;  1:Baseline; 2:Training 4:Test
    varargin)  % key-value pairs, where key is choosen form "withShadow","shocks","extinction point", value is boolean.
    if mod(length(varargin),2)~=0
        error('The arguments should be in pairs,such as ("withShadow",1,"shocks",0,"extPt",1)')
    end
    keys = string(varargin(1:2:end));
    values = varargin(2:2:end);
    
    shadowFlag = false;
    shockFlag = false;
    extinctFlag = false;
    if ~isempty(find(contains(keys,'withShadow','IgnoreCase',true), 1))
        shadowFlag = true;
    end
    if ~isempty(find(contains(keys,'shock','IgnoreCase',true), 1))
        shockFlag = true;
    end
    if ~isempty(find(contains(keys,'ext','IgnoreCase',true), 1))
        extinctFlag = true;
    end
    
    
     
    
    frameRate = obj.FrameRate;
    height = obj.ConfinedRect(4);
    pixelSize = 30/height; % mm/pixel
    yDiv = obj.yDivide;
    tempPIdx = cat(1,obj.Frames.PatternIdx);
    tempHeads = cat(1,obj.Frames.Head);
    phases = cat(1,obj.Frames.ExpPhase);
    
    if phase == 0 % plot the entire experimental process
        idxPhase = 1:length(phases);
        t = idxPhase / frameRate / 60; % min
        pIdx = tempPIdx(idxPhase);
        headY = tempHeads(idxPhase,2);
        y2CL = calcDist2Centerline(pIdx,headY,yDiv,pixelSize);
        
        % plot figure
        hold on;
        
        % plot shadows if asked
        if shadowFlag
            Y = [-15 15 15 -15];
            X1 = [0 0 10 10];
            X2 = [30 30 31 31];
            fill(X1,Y,[0.9,0.9,0.9],'EdgeColor','none');
            fill(X2,Y,[0.9,0.9,0.9],'EdgeColor','none');
        end
        
        scatter(t,y2CL,'k.');
        
        % plot shocking events if asked
        if shockFlag
            shockTiming = obj.Res.PIshock.ShockTiming / frameRate / 60 + 10;
            scatter(shockTiming,14.5*ones(length(shockTiming),1),8,'r.');
        end
        
        % plot the extinction point if asked
        if extinctFlag
            extinctTime = obj.Res.ExtinctTime/60 + 31;
            scatter(extinctTime,0,'b^');
        end
        
        xlim([0,50]);
        ylim([-15,15]);
        xlabel('Time (min)');
        ylabel('Distance to centerline (mm)');
        
    elseif (phase - 1)*(phase - 2)*(phase - 4) == 0 % plot the baseline period
        idxPhase = find(phases == phase - 1);
        t = idxPhase / frameRate / 60; % min
        pIdx = tempPIdx(idxPhase);
        headY = tempHeads(idxPhase,2);
        y2CL = calcDist2Centerline(pIdx,headY,yDiv,pixelSize);
        
        % plot figure
        hold on;
        
        scatter(t,y2CL,'k.');
        
        xlim([min(t)-1,max(t)+1]);
        ylim([-15,15]);
        xlabel('Time (min)');
        ylabel('Distance to Centerline (mm)');
        
    elseif phase == 3 % currently not supported
        error('Sorry, it is not supported currently.\n');
    else
        error('Wrong input. Please enter 0. the entire process; 1. baseline; 2. training; 3. Test');
    end
    
   
end

function y2CL = calcDist2Centerline(pIdx,headY,yDiv,pixelSize)
    numFrames = length(pIdx);
    y = zeros(numFrames,1);% distance (in y) to center line
    for i=1:numFrames
        if pIdx(i) == 0
            y(i) = headY(i) - yDiv;
        elseif pIdx(i) == 1
            y(i) = yDiv - headY(i);
        end
    end
    
    %     idx = abs(y) > 200; % remove unreasonable points
    %     y(idx) = nan;
    y2CL = y*pixelSize; % mm

end

