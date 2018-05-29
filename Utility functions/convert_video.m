function convert_video()
    [f,p] = uigetfile('*.avi');
    fileName = [p,f];
    vObj = VideoReader(fileName);
    newFileName = strcat(p,'new_',f);
    newVObj = VideoWriter(newFileName);
    open(newVObj);
    idxFrame = 0;
    while hasFrame(vObj)
        idxFrame = idxFrame + 1;
        if (mod(idxFrame,100) == 0)
            disp(idxFrame);
        end
        frame = readFrame(vObj);
        writeVideo(newVObj,frame);
    end
    
end