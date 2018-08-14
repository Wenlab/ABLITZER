% TODO: add a GUI for reading video
% TODO: add press esc to quit
function annotateRawVideo_cut(expData)

    startFrame = 21800;
   [f,p] = uigetfile('*.avi');
    videoName = [p,f];
     newFileName = strcat(p,'new_',f);
    newVObj = VideoWriter(newFileName);
    open(newVObj);
  
yDiv =209;
vObj = VideoReader(videoName);
h = figure;
for i=21800:24000
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

        line([0,366],[yDiv,yDiv],...
            'color','r','lineWidth',1.5);


        if (expData.PatternIdx2(i) == 0)
            text(20,10, 'CS TOP');
        elseif (expData.PatternIdx2(i) == 1)
            text(20, 10, 'CS BOTTOM');


        end

        writeVideo(newVObj,img);
    end


        pause(0.1);
end
end
