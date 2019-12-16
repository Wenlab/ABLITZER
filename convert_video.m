function convert_video()
    [f,p] = uigetfile('*.avi');
    fileName = [p,f];
    vObj = VideoReader(fileName);
    newFileName = strcat(p,'new_',f);
    newVObj = VideoWriter(newFileName);
    open(newVObj);
    while hasFrame(vObj)
        frame = readFrame(vObj);
        writeVideo(newVObj,frame);
    end
    
end