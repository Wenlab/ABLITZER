

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

prompt = {'Enter max parameciums area:','Enter min parameciums area:'};
dlg_title = 'Select paramecium bw Area Range';
num_lines = 1;
def = {num2str(0), num2str(0)};
answer = inputdlg(prompt,dlg_title,num_lines,def);
area_max = floor(str2double(answer{1}));
area_min = floor(str2double(answer{2}));

N=iend-istart+1;

vidObj=VideoReader(fname);

fps=vidObj.FrameRate;
total_frames=round(fps*vidObj.Duration);

%numcurvpts=100;
MaxNumcurvpts=140;


spline_p = 1e-4;

curvdata=zeros(N,MaxNumcurvpts);
angledata=zeros(N,MaxNumcurvpts+1);
head_orientation=zeros(N,1);

fishlength = zeros(N,1);
%-----------------------------------------
para_positions = zeros(N,2);
head_positions = zeros(N,2);
head_para_distance = zeros(N,1);
head_para_azimuth = zeros(N,1);
%head_para_azi = zeros(N,1);
head_anguvelo = zeros(N-5,1);
%-----------------------------------------


skip = floor((iend-istart+1)/5);

for j=istart:skip:iend 
    img = read(vidObj,j);
    if j == istart 
        imgsum = single(img(:,:,1));
        [ysize, xsize ] = size(img(:,:,1));
    end

    figure(1); 
    imagesc(img); axis equal; axis off; colormap gray; hold on;
    axis image;    title(num2str(j));
    
    imgsum = imgsum + single(img(:,:,1));
end


figure(1);clf;
imagesc(imgsum); axis equal; axis off; colormap gray; hold on;
title('sum image');

text(10,20, 'select ROI: upper left then lower right', 'Color', 'white');
[cropx1, cropy1 ] = ginput(1);
cropx1= floor(cropx1);
cropy1  = floor(cropy1);
plot([1 xsize], [cropy1 cropy1], '-r');
plot([cropx1 cropx1], [1 ysize], '-r');
[cropx2, cropy2 ] = ginput(1);
cropx2 = floor(cropx2);
cropy2 = floor(cropy2);
plot([1 xsize], [cropy2 cropy2], '-r');
plot([cropx2 cropx2], [1 ysize], '-r');
figure (1);

xlength = cropx2-cropx1;
ylength = cropy2-cropy1;


for j=istart:iend
    
    i=j-istart+1;
    img_Frame=read(vidObj,j);
    img_frame=img_Frame(cropy1:cropy2,cropx1:cropx2,1);
    
    
    se = strel('disk',20);
    Itop = imtophat(img_frame(:,:,1), se);
    
    
    %Ibot = imbothat(img(:,:,1), se);
    %img_enhanced=imsubtract(imadd(Itop, img(:,:,1)), Ibot);
    
    level=graythresh(Itop);
    img_bw=im2bw(Itop,0.7*level);
    se=strel('disk',3);
%------------------------------------------------------------    
%
    img_paramecium = bwareaopen(img_bw,area_min)-bwareaopen(img_bw,area_max);
    img_point = bwmorph(img_paramecium,'shrink',Inf);
    [pointsx,pointsy] = find(img_point==1);
    position = [pointsx,pointsy];
%
%------------------------------------------------------------   
    
%    edged=edge(Itop,'Prewitt');
    
 %   img_bw=img_bw|edged;
    
    
    img_bw=imclose(img_bw,se);
 %   img_bw=imfill(img_bw,'holes');
    img_bw = bwareaopen(img_bw,200);
    
    se2=strel('disk',7);
    
    img_bw_head = imopen(img_bw,se2);
    
    

    
    
    if (i==1)
%-------------------------------------------------
%
        figure (1);
        cla;
        imagesc(img_frame); axis off; axis equal; hold on;
        text(10,20,['Please select a region that' 10 'contains paramacius'],'Color','white');
        [squarex1,squarey1] = ginput(1);
        plot([1 xlength], [squarey1 squarey1], '-r');
        plot([squarex1 squarex1], [1 ylength], '-r');
        [squarex2,squarey2] = ginput(1);
        plot([1 xlength], [squarey2 squarey2], '-r');
        plot([squarex2 squarex2], [1 ylength], '-r');
        
        para_xnum = find(position(:,2)>=squarex1 & position(:,2)<=squarex2);
        para_ynum = find(position(:,1)>=squarey1 & position(:,1)<=squarey2);
        para_num = intersect(para_xnum,para_ynum);

        paramecium_position = position(para_num,:);
%
%-----------------------------------------------
        figure (1);
        cla;
        imagesc(img_frame); axis off; axis equal; hold on;
        text(10,20, 'Please let the computer know where the head is', 'Color', 'white');
        [x,y]=ginput(1);
        head(1)=y;
        head(2)=x;
        hold on; plot(x,y,'ro');
        D=bwdist(~img_bw_head);
        [~,idx]=max(D(:));
        [I,J]=ind2sub(size(D),idx);
        head_center=[I,J];
        vh=head-head_center;
        head_orientation_prior=angle(vh(2)-sqrt(-1)*vh(1));
    else
%----------------------------------------------
%
        r_squares = (position(:,1)-paramecium_position(1)).^2+(position(:,2)-paramecium_position(2)).^2;
        rsquare_min = min(r_squares);
        para_num = find(r_squares == rsquare_min);

        paramecium_position = position(para_num,:);
%
%---------------------------------------------------
        head_orientation_prior=head_orientation(i-1);
    end
    
    [headbacktip,head,head_orientation(i)]=compute_head_position(img_bw_head,head_orientation_prior);
    
    [centerline,path1,path2,tail]=compute_centerline(img_bw_head,img_bw,head,headbacktip);
    [smoothed_centerline,cv2,splen] = spline_line(centerline,spline_p,MaxNumcurvpts);
%--------------------------------
    para_positions(i,:) = paramecium_position;
    head_positions(i,:) = head;
    head_para_distance(i) = norm(paramecium_position-head);
    head_para_azimuth(i) =  asind(det([paramecium_position-head;head_center-head])/norm(paramecium_position-head)/norm(head_center-head));
    %head_para_azi(i) = acosd(dot(paramecium_position-head,head_center-head)/norm(paramecium_position-head)/norm(head_center-head));
%--------------------------------
    
    % interpolate to equally spaced length units and calculate the
    % curvature of the centerline
    %cv2i = interp1(splen+.00001*(0:length(splen)-1),cv2, (0:(splen(end)-1)/(numcurvpts+1):(splen(end)-1)));
    
      
    df2 = diff(smoothed_centerline,1,1); 
    atdf2 =  unwrap(atan2(-df2(:,2), df2(:,1)));
    
    numcurvpts = round(splen(end)/2);
    fishlength(i) = splen(end);
    

    angledata(i,1:numcurvpts) = atdf2';
    
    curv = unwrap(diff(atdf2,1));   
    
    curv=curv*numcurvpts/splen(end);
    
    curvdata(i,1:numcurvpts-1)=curv'*splen(end); %normalize curvature by the total length of the fish
    i=i+1;
    
    figure (1);
    cla;
    title(strcat(strcat(num2str(j), '/'), num2str(total_frames)), 'Interpreter', 'None');
    imagesc(img_frame); axis off; axis equal; hold on;
%---------------------------------
    scatter(paramecium_position(2),paramecium_position(1),'MarkerEdgeColor','y');hold on;
%----------------------------------
    plot(path1(:,2),path1(:,1),'-r'); hold on;
    plot(path2(:,2),path2(:,1),'-g'); hold on;
    plot(smoothed_centerline(:,1),smoothed_centerline(:,2), '-b'); hold on;
    plot(head(2),head(1),'ro');
    plot(tail(2),tail(1),'go');
    plot(headbacktip(2),headbacktip(1),'bo');
    pause (0.1);
 
end

answer = inputdlg({'time filter', 'body coord filter', 'mean=0, median=1'}, '', 1, {num2str(2), num2str(10), '0'});
timefilter = str2double(answer{1});
bodyfilter = str2double(answer{2});


cmap=redgreencmap;
cmap(:,3)=cmap(:,2);
cmap(:,2)=0;

h = fspecial('average', [timefilter bodyfilter]);
%curvdatafiltered = imfilter(curvdata,  h , 'replicate');
curvdatafiltered = curvdata;

figure; imagesc(curvdatafiltered(:,:)); colormap(cmap); colorbar; caxis([-1 1]);

title('cuvature diagram');

set(gca,'XTICK',[1 20 40 60 80 100 120 140]);
set(gca,'XTICKLABEL',2*[1 20 40 60 80 100 120 140]);

numframes=iend-istart+1;
set(gca,'YTICK',1:10*fps:numframes);
y_tick=get(gca,'YTICK');
set(gca,'YTICKLABEL',(y_tick-1)/fps);

xlabel('distance along the centerline (pixel)');
ylabel('time (s)');

hold on;plot(fishlength/2,1:N,'Color','y','LineWidth',1);

for j=istart:iend-5
    
   i=j-istart+1;
 
   head_anguvelo(i+5) =( head_orientation(i+5)- head_orientation(i))/5;
end


