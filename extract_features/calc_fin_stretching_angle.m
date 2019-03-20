function [leftFinAngle,rightFinAngle]=calc_fin_stretching_angle(showFlag)
% To calcualte the stretching angle of each fin to the body when fish
% swimming

% Get bending position(normalized) and bending angle from low resolution fish video
    % Read video from file
    [filename,pathname]  = uigetfile({'*.avi'});
    fname=[pathname filename];
    vidObj=VideoReader(fname);
    
    % Initialize output variables
    numFrame = floor(vidObj.Duration*vidObj.FrameRate); % Convert double to int
    leftFinAngle = zeros(numFrame,1);
    rightFinAngle = zeros(numFrame,1);


    for i=1:numFrame
        fprintf('Frame: %d\n',i);
        img = readFrame(vidObj);% read next available frame
        bwFish = get_bwFish(img);       
        
        %Extract the left and right fin from the image.
        se = strel('disk',15);
        bwErode = imerode(bwFish,se);
        bwDilate = imdilate(bwErode,se);
        [headPosition,tailPosition]=get_fish_head(bwDilate);
        bwSub = bwFish - bwDilate;
        bwFins = bwareaopen(bwSub,170);
        [leftFinAngle(i),rightFinAngle(i)]=calc_fin_body_interangle(bwFins,tailPosition,headPosition);

        % Visualize your results
        if showFlag
            figure(1);
            imshow(bwFish);
            hold on;
            scatter([headPosition(1),tailPosition(1)],[headPosition(2),tailPosition(2)],'b*');
            hold off;
            figure(2);
            imshow(bwDilate);
            pause;
        end
    end

end

function [leftFinAngle,rightFinAngle]=calc_fin_body_interangle(bwFins,tailPosition,headPosition)
    L = bwlabel(bwFins);
    if max(L(:)) == 1
        [r1,c1] = find(L==1);     
        numPoint = length(r1);
        distArray = zeros(numPoint,1);
        for i = 1:numPoint
            distArray(i) = point_to_line([c1(i),r1(i)],tailPosition,headPosition);
        end
        minIdx = find(distArray==min(distArray),1);
        maxIdx = find(distArray==max(distArray),1);
        head2tail = tailPosition - headPosition;
        vecMIn = [c1(minIdx),r1(minIdx)] - tailPosition;
        vecFin = [c1(minIdx),r1(minIdx)] - [c1(maxIdx),r1(maxIdx)];
        k1 = vecMIn(2)/vecMIn(1);
        k2 = head2tail(2)/head2tail(1);
        sgn = (k1-k2)/(1+k1*k2);
        if sgn > 0
            leftFinAngle = rad2deg(acos(vecFin*head2tail'/norm(vecFin)/norm(head2tail)));
            rightFinAngle = 0;
        else
            rightFinAngle = rad2deg(acos(vecFin*head2tail'/norm(vecFin)/norm(head2tail)));
            leftFinAngle = 0;
        end
    elseif max(L(:)) == 2
        [r1,c1] = find(L==1);
        numPoint = length(r1);
        distArray = zeros(numPoint,1);
        for i = 1:numPoint
            distArray(i) = point_to_line([c1(i),r1(i)],tailPosition,headPosition);
        end
        minIdx = find(distArray==min(distArray),1);
        maxIdx = find(distArray==max(distArray),1);
        head2tail = tailPosition - headPosition;
        vecMIn = [c1(minIdx),r1(minIdx)] - tailPosition;
        vecFin1 = [c1(minIdx),r1(minIdx)] - [c1(maxIdx),r1(maxIdx)];
        k1 = vecMIn(2)/vecMIn(1);
        k2 = head2tail(2)/head2tail(1);
        sgn = (k1-k2)/(1+k1*k2);
        
        [r2,c2] = find(L==2);     
        numPoint = length(r2);
        distArray = zeros(numPoint,1);
        for i = 1:numPoint
            distArray(i) = point_to_line([c2(i),r2(i)],tailPosition,headPosition);
        end
        minIdx = find(distArray==min(distArray),1);
        maxIdx = find(distArray==max(distArray),1);
        vecFin2 = [c2(minIdx),r2(minIdx)] - [c2(maxIdx),r2(maxIdx)];
        
        if sgn > 0
            leftFinAngle = rad2deg(acos(vecFin1*head2tail'/norm(vecFin1)/norm(head2tail)));
            rightFinAngle = rad2deg(acos(vecFin2*head2tail'/norm(vecFin2)/norm(head2tail)));
        else
            leftFinAngle = rad2deg(acos(vecFin2*head2tail'/norm(vecFin2)/norm(head2tail)));
            rightFinAngle = rad2deg(acos(vecFin1*head2tail'/norm(vecFin1)/norm(head2tail)));
        end
        
    else
        leftFinAngle = 0;
        rightFinAngle = 0;
    end
    
    
end

function d = point_to_line(pt, v1, v2)
      c = v1 - v2;
      b = pt - v2;
      a = pt - v1;
      d = norm(a)*norm(b)/norm(c)*sin(acos(a*b'));
end

function bwFish = get_bwFish(img)
    % extract fish from a noisy background in a video frame
    grayImg = rgb2gray(img);
    bw=adaptivethreshold(grayImg,50,0.001);%3rd party package
    bw2 = find_central_fish(bw);    
    se = strel('disk',15);
    bwDilate = imdilate(bw2,se);
    bwErode = imerode(bwDilate,se);
    bwFish = imfill(bwErode,'holes');
    
end

function bw3 = remove_areas_not_in_range(bw)
    % set upbound and threshold to remove areas not fish
    threshold = 1000;
    upbound = 200000;
    bw1 = bwareaopen(bw,threshold);
    bw2 = bwareaopen(bw,upbound);
    bw3 = bw1 - bw2;
    
end

function bw = remove_white_on_boundary(bw)
    % turn all white points in selected area to black in selected region
    [rowSize,colSize] = size(bw);
    width = colSize/2;
    for r = 1:rowSize
        for c = 1:colSize
            dist2center = norm([r,c]-[rowSize/2,colSize/2]);
            if dist2center > width
                bw(r,c) = 0;
            end
        end
    end
    
end

function bw2 = find_central_fish(bw)
    L = bwlabel(bw);
    numArea = max(L(:));
    A = zeros(numArea,1);
    for i=1:numArea
        A(i) = length(find(L==i));
    end
    [~,IDX]=sort(A,'descend');
    idx = find(L==IDX(2));
    bw2 = zeros(size(bw));
    bw2(idx) = 1;%set fish region to 1
end

function [headPosition,tailPosition]=get_fish_head(bwFish)
    [yWhite,xWhite] = find(bwFish);
    P = [xWhite';yWhite'];
    bb = minBoundingBox(P); % 3rd party code
    
    len1 = bb(:,4)-bb(:,1);% For more details, refer minBoundingBox.m
    len2 = bb(:,2)-bb(:,1);
    if(len1 < len2)
        box1 = [bb(:,1),(bb(:,1)+bb(:,2))/2,(bb(:,3)+bb(:,4))/2,bb(:,4)];
        box2 = [bb(:,2),(bb(:,1)+bb(:,2))/2,(bb(:,3)+bb(:,4))/2,bb(:,3)];
        
        xv1 = box1(1,:); 
        yv1 = box1(2,:);
        area1 = length(find(inpolygon(xWhite,yWhite,xv1,yv1)));
        
        xv2 = box2(1,:);
        yv2 = box2(2,:);
        area2 = length(find(inpolygon(xWhite,yWhite,xv2,yv2)));
        
        if (area1 > area2)
            headPosition = (bb(:,4) + bb(:,1))/2;  
            tailPosition = (bb(:,2) + bb(:,3))/2; 
        else
            headPosition = (bb(:,2) + bb(:,3))/2;
            tailPosition = (bb(:,4) + bb(:,1))/2; 
        end
    else
        box1 = [bb(:,1),(bb(:,1)+bb(:,4))/2,(bb(:,3)+bb(:,2))/2,bb(:,2)];
        box2 = [bb(:,4),(bb(:,1)+bb(:,4))/2,(bb(:,3)+bb(:,2))/2,bb(:,3)];
        
        xv1 = box1(1,:); 
        yv1 = box1(2,:);
        area1 = length(find(inpolygon(xWhite,yWhite,xv1,yv1)));
        
        xv2 = box2(1,:);
        yv2 = box2(2,:);
        area2 = length(find(inpolygon(xWhite,yWhite,xv2,yv2)));
        
        if (area1 > area2)
            headPosition = (bb(:,2) + bb(:,1))/2;
            tailPosition = (bb(:,4) + bb(:,3))/2;
        else
            headPosition = (bb(:,4) + bb(:,3))/2;
            tailPosition = (bb(:,2) + bb(:,1))/2;
        end
        
    end
    headPosition = floor(headPosition');
    tailPosition = floor(tailPosition');
end
