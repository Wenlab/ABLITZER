function plotDist2centerline(obj)
    frameRate = obj.FrameRate;
    height = obj.ConfinedRect(4);
    yStart = obj.ConfinedRect(2);
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

    figure;
    t = (1:numFrames) / frameRate / 60; % convert it to mins
    scatter(t,y,8,'k.');
    ylim([-15,15]);
    xlim([0,50]);
    xlabel('Time (min)');
    ylabel('Distance to centerline (mm)');

    hold on;
    scatter(shockTiming, 14*ones(size(shockTiming)),8,'r.');


end
