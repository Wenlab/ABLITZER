
% TODO: add a GUI for reading video
% TODO: add press esc to quit
function annotateRawVideo(obj,startFrame,videoName)
if nargin == 1
    startFrame = 1;
    [f,p] = uigetfile();
    videoName = [p,f];
elseif nargin == 2
   [f,p] = uigetfile('*.avi');
    videoName = [p,f];
end
yDiv = obj.yDivide;
cBox = obj.ConfinedRect;
vObj = VideoReader(videoName);
frames = obj.Frames;

% For testing code
turnTiming = cat(1,obj.Res.PIturn.TurnTiming);
turnScores = cat(1,obj.Res.PIturn.Scores);
idx = find(turnScores);
turnTiming = turnTiming(idx);
turnScores = turnScores(idx);
h = figure;
for i=1:length(frames)
    if ~hasFrame(vObj)
        return;
    end
    img = readFrame(vObj);
    if (mod(i,100) == 0)
        disp(i);
    end
    
    if (i > startFrame)
        figure(h.Number);
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
        
%         line([cBox(1),cBox(1) + cBox(3)],...
%             [yDiv-2*obj.Res.BodyLength,yDiv-2*obj.Res.BodyLength],...
%             'color','b','lineWidth',1,'lineStyle','-.');
%         
%         line([cBox(1),cBox(1) + cBox(3)],...
%             [yDiv+2*obj.Res.BodyLength,yDiv+2*obj.Res.BodyLength],...
%             'color','b','lineWidth',1,'lineStyle','-.');
        
%         line([77,77],[cBox(2),cBox(2) + cBox(4)],...
%             'color','b','lineWidth',1,'lineStyle','-.');
%         
%         line([340,340],[cBox(2),cBox(2) + cBox(4)],...
%             'color','b','lineWidth',1,'lineStyle','-.');
        
        
        
        if (frame.PatternIdx == 0)
            text(10, 10, 'CS TOP');
        elseif (frame.PatternIdx == 1)
            text(10, 10, 'CS BOTTOM');
        end
        if (frame.ShockOn)
            text(10, 30, 'Shock on');
        end
        
%         % test turning scores
%         idx = find(turnTiming == i);
%         if ~isempty(idx)
%             if turnScores(idx) == 1
%                 text(10,50,'Good turn','color','red','FontSize',14);
%             elseif turnScores(idx) == -1
%                 text(10,50,'Bad turn','color','red','FontSize',14);
%             else
%                 text(10,50,'Just a turn','color','red','FontSize',14);
%             end
%             pause();
%         end
%         
        
        str = sprintf('Frame: %d',i);
        text(10,760,str);
        pause(0.1);
    end
end

end