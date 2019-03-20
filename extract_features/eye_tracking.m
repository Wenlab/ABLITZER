function eye_tracking()

for order = 1:1
    fprintf('This is the %d th video\n',order);

pathname = 'G:\Wenbin\zebrafish_automation\data\fish video\non-prey1\20161117_2129\';
filename = strcat('20161117_2129_high_',num2str(order),'.avi');
[filename,pathname]  = uigetfile({'*.avi'});
fname=[pathname filename];


vidObj=VideoReader(fname);
numFrames = get(vidObj,'NumberOfFrames');

istart=1;
iend=floor(numFrames);
fps=vidObj.FrameRate;
vidObj=VideoReader(fname);

total_frames=round(fps*vidObj.Duration);
N=iend-istart+1;

Convergence_angle=zeros(N,1);
Centroid_distance=zeros(N,1);
eye1_area=zeros(N,1);
eye2_area=zeros(N,1);
for j=istart:iend
    try
        i=j-istart+1;
       
        img=read(vidObj,j);
        level=graythresh(img);
        bw=im2bw(img, 0.6*level);%0.8
        se = strel('disk',10);
        bw1 = imdilate(bw,se);
        bw2 = imerode(bw1,se);
        bw = bw2;
        P = regionprops(bw,'Orientation');
        headOrientation = P.Orientation;
        
        closebw=imfill(bw,'holes');
        eye_bw = closebw - bw;
        eye_bw = bwareaopen(eye_bw,100);
        figure(2);
        imshow(eye_bw);
        pause(0.1);
        
        stats=regionprops(eye_bw,'Area','MajorAxisLength','MinorAxisLength','Orientation','Centroid','BoundingBox');
        
        areas=cat(1,stats.Area);
        [~,IDX]=sort(areas,'descend');
        
        eye1=stats(IDX(1));
        eye2=stats(IDX(2));
        
        figure (1);
        cla;
        title(strcat(strcat(num2str(j), '/'), num2str(total_frames)), 'Interpreter', 'None');
        imagesc(img); axis off; axis equal; hold on;
        
        colormap(gray);
        eye1_area(i)=eye1.Area;
        
        eye2_area(i)=eye2.Area;
        
        Centroid_distance(i)=norm(eye1.Centroid-eye2.Centroid);
        %if  ((eye1_area(i)>500)&&(eye2_area(i)>500))
            Convergence_angle(i)=max(eye1.Orientation,eye2.Orientation)-min(eye1.Orientation,eye2.Orientation);
            hold on; ellipse(eye1.MinorAxisLength/2,eye1.MajorAxisLength/2,pi/2-eye1.Orientation/180*pi,eye1.Centroid(1),eye1.Centroid(2),'r');
            hold on; ellipse(eye2.MinorAxisLength/2,eye2.MajorAxisLength/2,pi/2-eye2.Orientation/180*pi,eye2.Centroid(1),eye2.Centroid(2),'r');
            pause(0.1);
        %else
            Convergence_angle(i)=NaN;
        %end
        
     catch
         Convergence_angle(i)=NaN;
         Centroid_distance(i)=0;
         continue;
    end
    
end
pathname = 'G:\Wenbin\zebrafish_automation\data\videos_clips_for_paper\capture2\';
filename = filename(1:end-4);
fName = [pathname filename];
save(fName,'Convergence_angle');

figure;

frame = istart:iend;
t = (frame-istart+1)/fps;

plot(t,Convergence_angle)
title('Convergence angle')
end
end