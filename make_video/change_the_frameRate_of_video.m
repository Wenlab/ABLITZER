function change_the_frameRate_of_video(frameRate)
    [filename,pathname]=uigetfile('*.avi');
    fname = [pathname filename];
    obj = VideoReader(fname);
    aviobj=VideoWriter('low_test.avi');
    aviobj.FrameRate=frameRate;%16.875
	open(aviobj);
    numFrame = floor(obj.Duration*obj.FrameRate);
    for i=1:numFrame
        f = read(obj,i);
        
        writeVideo(aviobj,f);
        
    end
    close(aviobj);
end