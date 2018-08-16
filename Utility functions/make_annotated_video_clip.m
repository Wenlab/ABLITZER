% to make selected video clip with annotations of fish head, CS positions
% and the playing speed.

function make_annotated_video_clip(fishObj,... % the obj of FISHDATA Class
    startFrame,... % frame index to start with
    endFrame,... % frame index to stop 
    xShift,... % shifting distance to the original origin in x-axis
    yShift) % shifting distance to teh original origin in y-axis
    
    clr = [1,1,1]; %white
    
    [f,p] = uigetfile('*.avi');
    fileName = [p,f];
    vObj = VideoReader(fileName);
    
    newVobj = VideoWriter(['Working/','Masked-',f]);
    newVobj.Quality = 100; % ensure no interpolation applied
    open(newVobj);
    
    heads = cat(1,fishObj.Frames(startFrame:endFrame).Head);
    heads(:,1) = heads(:,1) - xShift;
    heads(:,2) = heads(:,2) - yShift;
    
    pIdx = cat(1,fishObj.Frames(startFrame:endFrame).PatternIdx);
    
    % Read the fist frame to get format infos
    frame = readFrame(vObj);
    % height = size(frame,1);
    width = size(frame,2);
    x = 1:5:width;
    yDiv = fishObj.yDivide - yShift; % the divided line
    
    fIdx = 1; % frame index
    while hasFrame(vObj)
        fIdx = fIdx + 1;
        I = readFrame(vObj);
        
        % draw the red dividing line
        I(yDiv,x,1) = 255;
        I(yDiv,x,2) = 0;
        I(yDiv,x,3) = 0;
        
        h = figure(1);
        cla reset; % clear prior image
        imshow(I,[]);
        hold on;
        
        % Annotate the frame
        if pIdx(fIdx) == 0
            text(20,10,'CS Top','color',clr,'FontSize',15);
        elseif pIdx(fIdx) == 1
            text(20,10,'CS Bottom','color',clr,'FontSize',15);
        end
        text(190,10,'Playing speed x3','color',clr,'FontSize',15);
%         if fIdx < extinctFrame
%             text(20,30,'Not extinct','color',clr,'FontSize',15);
%         else
%             text(20,30,'Memory extinct','color',clr,'FontSize',15);
%         end

        % Annotate the fish positions
        scatter(heads(fIdx,1),heads(fIdx,2),20,'bo');
        %scatter(centers(i,1),centers(i,2),10,'b*');

        F = getframe(h);
        writeVideo(newVobj,F.cdata);
        
    end
    close(newVobj);
    


end