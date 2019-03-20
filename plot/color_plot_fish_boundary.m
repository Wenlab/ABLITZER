function color_plot_fish_boundary()
    % from GUI, read avi video for analyzing
    [filename,pathname]  = uigetfile({'*.png'});
    fname=[pathname filename];
    img = imread(fname);
    
    grayImg = rgb2gray(img);
    level = graythresh(grayImg);
    bw = im2bw(grayImg,0.45*level);
    
    se = strel('disk',4);
    bwDilate = imdilate(bw,se);
    bwErode = imerode(bwDilate,se);
    
    bwFish = imfill(bwErode,'holes');
    B = bwboundaries(bwFish,'noholes');
    boundLength = zeros(size(B));
    for i=1:length(B)
        boundLength(i) = length(B{i,1});
    end
    idx = find(boundLength==max(boundLength));
    fishBound = B{idx,1};
    
    figure;
    imshow(img);
    hold on;
    lw = 1; % line width
    plot(fishBound(:,2),fishBound(:,1),'r','LineWidth',lw+1);
    
    for i=1:length(fishBound)
        img(fishBound(i,1)-lw:fishBound(i,1),fishBound(i,2)-lw:fishBound(i,2)+lw,1) = 255;
        img(fishBound(i,1)-lw:fishBound(i,1),fishBound(i,2)-lw:fishBound(i,2)+lw,2) = 0;
        img(fishBound(i,1)-lw:fishBound(i,1),fishBound(i,2)-lw:fishBound(i,2)+lw,3) = 0;
    end
    
    
    Fname = strcat(fname(1:end-4),'_with_boundary.png');
    imwrite(img,Fname);

end