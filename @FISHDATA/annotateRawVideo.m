
% TODO: add a GUI for reading video
function annotateRawVideo(obj,startFrame,videoName)
if nargin == 1
    startFrame = 1;
    [f,p] = uigetfile('*.avi');
    videoName = [p,f];
elseif nargin == 2
   [f,p] = uigetfile('*.avi');
    videoName = [p,f];
end
yDiv = obj.yDivide;
cBox = obj.ConfinedRect;
vObj = VideoReader(videoName);
frames = obj.Frames;
for i=1:length(frames)
    img = readFrame(vObj);
    if (mod(i,100) == 0)
        disp(i);
    end
    
    if (i > startFrame)
        figure(1);
        cla reset; % clear prior image
        imshow(img,[]);
        hold on;
        % Annotate head, tail positions and pattern
        frame = frames(i);
        scatter(frame.Head(1),frame.Head(2),'ro');
        scatter(frame.Tail(1),frame.Tail(2),'b*');
        scatter(frame.Center(1),frame.Center(2),'y.');
        
        line([cBox(1),cBox(1) + cBox(3)],[yDiv,yDiv],...
            'color','r','lineWidth',1.5);
        
        if (frame.PatternIdx == 0)
            text(10, 10, 'CS TOP');
        elseif (frame.PatternIdx == 1)
            text(10, 10, 'CS BOTTOM');
        end
        if (frame.ShockOn)
            text(10, 30, 'Shock on');
        end
        
        str = sprintf('Frame: %d',i);
        text(10,760,str);
        pause(0);
    end
end

end