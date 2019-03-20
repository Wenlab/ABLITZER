function [leftEye2CenterlineAngle,rightEye2CenterlineAngle,convergenceAngle]=analyze_fish_eye_convergence_angle(showFlag)

% from GUI, read avi video for analyzing
[filename,pathname]  = uigetfile({'*.avi'});
fname=[pathname filename];
vidObj=VideoReader(fname);

% convert double to int
numFrame = floor(vidObj.Duration*vidObj.FrameRate);

% Initialization of output variables
convergenceAngle=zeros(numFrame,1);
leftEye2CenterlineAngle=zeros(numFrame,1);
rightEye2CenterlineAngle=zeros(numFrame,1);

% Read frame one by one
for i=1:numFrame
    try
    fprintf('Frame: %d\n',i);
    img=readFrame(vidObj);% read next available frame
    
    % Extract binary fish from image
    bwFish = get_bwFish(img);
    
    % Get leftEye, rightEye and headOrientaion by the head-tail vector
    [leftEye,rightEye,headOrientation] = determine_relative_position(bwFish);
    
    
    
    leftEye2CenterlineAngle(i) = abs(leftEye.Orientation - headOrientation);
    if leftEye2CenterlineAngle(i) > 90 % due to the physical limitation, this angle cannot exceed 90 degrees
        leftEye2CenterlineAngle(i) = 180 - leftEye2CenterlineAngle(i);
    end
    rightEye2CenterlineAngle(i) = abs(rightEye.Orientation - headOrientation);
    if rightEye2CenterlineAngle(i) > 90
        rightEye2CenterlineAngle(i) = 180 - rightEye2CenterlineAngle(i);
    end
    convergenceAngle(i)= leftEye2CenterlineAngle(i) + rightEye2CenterlineAngle(i);
    
    if showFlag  
        figure (1);
        cla;
        title(strcat(strcat(num2str(i), '/'), num2str(numFrame)), 'Interpreter', 'None');
        imagesc(img); axis off; axis equal; hold on;

        colormap(gray);
        % ellipse is a 3rd party function
        hold on; ellipse(leftEye.MinorAxisLength/2,leftEye.MajorAxisLength/2,pi/2-leftEye.Orientation/180*pi,leftEye.Centroid(1),leftEye.Centroid(2),'r');
        hold on; ellipse(rightEye.MinorAxisLength/2,rightEye.MajorAxisLength/2,pi/2-rightEye.Orientation/180*pi,rightEye.Centroid(1),rightEye.Centroid(2),'r');
        pause;
    end
    
    
    catch
        leftEye2CenterlineAngle(i) = nan;
        rightEye2CenterlineAngle(i) = nan;
        convergenceAngle(i) = nan;
    end
end

end

function [leftEye,rightEye,headOrientation]=determine_relative_position(bwFish)
    [yWhite,xWhite] = find(bwFish);
    P = [xWhite';yWhite'];
    bb = minBoundingBox(P); % 3rd party code
    
    % Get 2 regions of eyes
    closebw=imfill(bwFish,'holes');
    bwEye = closebw - bwFish;
    bwEye = bwareaopen(bwEye,100);
    
    
    stats=regionprops(bwEye,'Area','MajorAxisLength','MinorAxisLength','Orientation','Centroid','BoundingBox');
    
    areas=cat(1,stats.Area);
    [~,IDX]=sort(areas,'descend');
    
    eye1=stats(IDX(1));
    eye1C = eye1.Centroid;
    eye2=stats(IDX(2));

    len1 = bb(:,4)-bb(:,1);% For more details, refer minBoundingBox.m
    len2 = bb(:,2)-bb(:,1);
    if(len1 < len2)
        box1 = [bb(:,1),(bb(:,1)+bb(:,2))/2,(bb(:,3)+bb(:,4))/2,bb(:,4)];
        %box2 = [bb(:,2),(bb(:,1)+bb(:,2))/2,(bb(:,3)+bb(:,4))/2,bb(:,3)];
        
        xv1 = box1(1,:);
        yv1 = box1(2,:);
        if (inpolygon(eye1C(1),eye1C(2),xv1,yv1))
            head = (bb(:,4) + bb(:,1))/2;
            tail = (bb(:,2) + bb(:,3))/2;
        else
            head = (bb(:,2) + bb(:,3))/2;
            tail = (bb(:,4) + bb(:,1))/2;
        end
    else
        box1 = [bb(:,1),(bb(:,1)+bb(:,4))/2,(bb(:,3)+bb(:,2))/2,bb(:,2)];
        %box2 = [bb(:,4),(bb(:,1)+bb(:,4))/2,(bb(:,3)+bb(:,2))/2,bb(:,3)];
        
        xv1 = box1(1,:);
        yv1 = box1(2,:);
        if (inpolygon(eye1C(1),eye1C(2),xv1,yv1))
            head = (bb(:,2) + bb(:,1))/2;
            tail = (bb(:,4) + bb(:,3))/2;
        else
            head = (bb(:,4) + bb(:,3))/2;
            tail = (bb(:,2) + bb(:,1))/2;
        end
        
    end
    tail = tail';
    head = head';
    
    vec1 = eye1C - tail;
    k1 = vec1(2)/vec1(1);
    %vec2 = eye2C - tail;
    tail2head = head - tail;
    k = tail2head(2)/tail2head(1);
    headOrientation = rad2deg(-atan(k));
    
    sgn = (k1 - k)/(1+k1*k);
    if (sgn<0)
        leftEye = eye1;
        rightEye = eye2;
    else
        leftEye = eye2;
        rightEye = eye1;
    end
    
end

function bwFish = get_bwFish(img)
    % extract fish from a noisy background in a video frame
    grayImg = rgb2gray(img);
    level = graythresh(grayImg);
    bw = im2bw(grayImg,0.6*level);
    %bw2 = remove_white_on_boundary(bw);
    %bw3 = remove_areas_not_in_range(bw2);
    se = strel('disk',10);
    bwDilate = imdilate(bw,se);
    bwFish = imerode(bwDilate,se);
    %bwFish = find_central_fish(bw3);
    
    
    
end