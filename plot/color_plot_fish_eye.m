function color_plot_fish_eye()
    [filename,pathname]  = uigetfile({'*.png'});
    fname=[pathname filename];
    img = imread(fname);
    
    grayImg = rgb2gray(img);
    level = graythresh(grayImg);
    bw = im2bw(grayImg,0.6*level);
    
    se = strel('disk',10);
    bwDilate = imdilate(bw,se);
    bwFish = imerode(bwDilate,se);
    
    % Get 2 regions of eyes
    closebw=imfill(bwFish,'holes');
    bwEye = closebw - bwFish;
    bwEye = bwareaopen(bwEye,100);
    
    stats=regionprops(bwEye,'Area','MajorAxisLength','MinorAxisLength','Orientation','Centroid','BoundingBox');
    
    areas=cat(1,stats.Area);
    [~,IDX]=sort(areas,'descend');
    
    eye1=stats(IDX(1));
    eye2=stats(IDX(2));
    
   
    figure;
    imshow(img);
    % ellipse is a 3rd party function
    lw = 1; % line width
    for i = 1:2*lw+1
        for j = 1:2*lw+1
        hold on; ellipse(eye1.MinorAxisLength/2+i-lw-1,eye1.MajorAxisLength/2+j-lw-1,pi/2-eye1.Orientation/180*pi,eye1.Centroid(1),eye1.Centroid(2),'r');
        hold on; ellipse(eye2.MinorAxisLength/2+i-lw-1,eye2.MajorAxisLength/2+j-lw-1,pi/2-eye2.Orientation/180*pi,eye2.Centroid(1),eye2.Centroid(2),'r');
        end
    end
end