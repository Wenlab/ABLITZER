% combine two videos into a single split screen video
close all
clc
clear
[filename1,pathname1] = uigetfile('*.avi');
fName1 = [pathname1 filename1];
vid1 = vision.VideoFileReader(fName1);

[filename2,pathname2] = uigetfile('*.avi');
fName2 = [pathname2 filename2];
vid2 = vision.VideoFileReader(fName2);
Vname = input('input the file name for video: ','s');
%aviobj=VideoWriter(aviname,'MPEG-4');
%open(aviobj);
%vidP = vision.VideoPlayer;
vidP = vision.VideoFileWriter(Vname,'FrameRate',30,'FileFormat','MPEG4');

while ~isDone(vid1)
   frame1 = step(vid1);
   frame2 = step(vid2);
   frame1 = imresize(frame1,[600,600]);
   frame2 = imresize(frame2,[600,600]);
   
   %fig = subplot(2,1,1);
   
   
   frame = horzcat(frame1, frame2);
   %im=frame2im(frame);
   %writeVideo(aviobj,frame);
   %writeVideo(aviobj,frame);
   step(vidP,frame);
   
   
end

%writeVideo(aviobj,vidP);
release(vid1);
release(vid2);
release(vidP);
%close(aviobj);

% %Read video
% clc
% clear
% vidObj_f = VideoReader('video1.mp4');
% FrameRate_f = vidObj_f.FrameRate;
% vidObj_b = VideoReader('video2.mp4');
% FrameRate_b = vidObj_b.FrameRate;
% 
% %New video
% outputVideo = VideoWriter('combinedvideo.avi');
% outputVideo.FrameRate = 24;
% open(outputVideo);
% 
% skip = 95; %first seconds
% j=skip*24;
% try
% while 1
%     front = read(vidObj_f,1+round(j*FrameRate_f*1/24));
%     back = read(vidObj_b,1+round(j*FrameRate_b*1/24));
%     front = imresize(front,[720 1280]);
%     videoframe = [front;back];
%     writeVideo(outputVideo, videoframe);
%     j = j+1;
% end
% catch
%     disp('...end 1');
% end
% 
% vidObj_f = VideoReader('video3.mp4');
% FrameRate_f = vidObj_f.FrameRate;
% vidObj_b = VideoReader('video4.mp4');
% FrameRate_b = vidObj_b.FrameRate;
% 
% skip = 0; %first seconds
% j=skip*24;
% try
% while 1
%     front = read(vidObj_f,1+round(j*FrameRate_f*1/24));
%     back = read(vidObj_b,1+round(j*FrameRate_b*1/24));
%     front = imresize(front,[720 1280]);
%     videoframe = [front;back];
%     writeVideo(outputVideo, videoframe);
%     j = j+1;
% end
% catch
%     disp('...end 2');
% end
% 
% vidObj_f = VideoReader('video5.mp4');
% FrameRate_f = vidObj_f.FrameRate;
% vidObj_b = VideoReader('video6.mp4');
% FrameRate_b = vidObj_b.FrameRate;
% 
% skip = 0; %first seconds
% j=skip*24;
% cut = 30; %after playing 'cut' seconds
% try
% while 1
%     front = read(vidObj_f,1+round(j*FrameRate_f*1/24));
%     back = read(vidObj_b,1+round(j*FrameRate_b*1/24));
%     front = imresize(front,[720 1280]);
%     videoframe = [front;back];
%     writeVideo(outputVideo, videoframe);
%     if j>cut*24
%         disp('...end 3 (cut)');
%         break
%     end
%     j = j+1;
% 
% end
% catch
%     disp('...end 3');
% end
% 
% close(outputVideo);
