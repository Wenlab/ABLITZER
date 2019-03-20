


if ~exist('vidObj', 'var')
   
    [filename,pathname]  = uigetfile({'*.avi'});

    fname=[pathname filename];
    
end

prompt = {'Enter what frame to start:','Enter what frame to end','Enter the frame rate (fps)'};
dlg_title = 'Select frame';
num_lines = 1;
def = {num2str(0), num2str(0),num2str(0)};
answer = inputdlg(prompt,dlg_title,num_lines,def);

istart=str2double(answer{1});
iend=str2double(answer{2});
fps=str2double(answer{3});

vidObj=VideoReader(fname);

fps=vidObj.FrameRate;
total_frames=round(fps*vidObj.Duration);

N=iend-istart+1;

Convergence_angle=zeros(N,1);

for j=istart:iend
    
    i=j-istart+1;
    img=read(vidObj,j);
    level=graythresh(img);
    bw=im2bw(img,0.8*level);

    se=strel('disk',20);

    closebw=imclose(bw,se);
    closebw=imfill(closebw,'holes');

    se2=strel('disk',10);

    bw2=imclose(bw,se2);

    %figure; imagesc(closebw);

    %bw=im2bw(img,0.8*level);
    eye_bw=(~bw2)&(closebw);
    %imfill(eye_bw,'holes');

    se2=strel('disk',2);

    eye_bw=imopen(eye_bw,se2);

    L=logical(eye_bw);

    stats=regionprops(L,'Area','MajorAxisLength','MinorAxisLength','Orientation','Centroid','BoundingBox');

    areas=cat(1,stats.Area);
    [~,IDX]=sort(areas,'descend');

    eye1=stats(IDX(1));
    eye2=stats(IDX(2));

    %figure; imshow(eye_bw);
    
    figure (1);
    cla;
    title(strcat(strcat(num2str(j), '/'), num2str(total_frames)), 'Interpreter', 'None');
    imagesc(img); axis off; axis equal; hold on;

    colormap(gray);

    hold on; ellipse(eye1.MinorAxisLength/2,eye1.MajorAxisLength/2,pi/2-eye1.Orientation/180*pi,eye1.Centroid(1),eye1.Centroid(2),'r');
    hold on; ellipse(eye2.MinorAxisLength/2,eye2.MajorAxisLength/2,pi/2-eye2.Orientation/180*pi,eye2.Centroid(1),eye2.Centroid(2),'r');
    
    Convergence_angle(i)=max(eye1.Orientation,eye2.Orientation)-min(eye1.Orientation,eye2.Orientation);
    
    %hold on; ellipse(eye1.MajorAxisLength/2, eye1.MinorAxisLength/2,eye1.Orientation/180*pi,eye1.Centroid(1),eye1.Centroid(2),'r');
    %hold on; ellipse(eye2.MajorAxisLength/2, eye2.MinorAxisLength/2,pi/2-eye2.Orientation/180*pi,eye2.Centroid(1),eye2.Centroid(2),'r');
    
    
    pause(0.1);
    
end



