function [bendingAngle,bendingPosition] = calc_fish_tail_bending(showFlag)
    % Get bending position(normalized) and bending angle from low resolution fish video
    % Read video from file
    [filename,pathname]  = uigetfile({'*.avi'});
    fname=[pathname filename];
    vidObj=VideoReader(fname);
    
    % Initialize output variables
    numFrame = floor(vidObj.Duration*vidObj.FrameRate); % Convert double to int
    bendingAngle = zeros(numFrame,1);
    bendingPosition = zeros(numFrame,1);
    
    % Read frame one by one
    for i=1:numFrame
        fprintf('Frame: %d\n',i);
        img = readFrame(vidObj);% read next available frame
        bwFish = get_bwFish(img);
        headPosition = get_fish_head(bwFish);
        [skelPath,headPosition,tailPosition] = get_skel_for_one_frame(bwFish,headPosition);
        sortedSkel = sort_the_skel(skelPath,headPosition);
        Cx = sortedSkel(:,2)';
        Cy = sortedSkel(:,1)';
        curv=calc_curvature(Cx,Cy);
        [bendingPosition(i),bendingAngle(i)]=calc_bendingAngle_and_bendingPosition(curv,sortedSkel);
        if showFlag
            figure(1);
            imshow(img);
            hold on;
            plot(Cx,Cy,'b');
            fprintf('Bending Position: %f\n',bendingPosition(i));
            fprintf('Bending Angle: %f\n',bendingAngle(i));
            pause(0.1);
            hold off;
        end
        
    end
end

function curv=calc_curvature(Cx,Cy)
numcurvpts = length(Cx);
% smooth
y = smooth(Cx,Cy,8);
y = y';
x = Cx;
centerLine = [x;y];

df = diff(centerLine,1,2);
t = cumsum([0, sqrt([1 1]*(df.*df))]); % cumulative sum starts with the first row
cv = csaps(t,centerLine,0.0005);
cv2 =  fnval(cv, t)';
df2 = diff(cv2,1,1); df2p = df2';

splen = cumsum([0, sqrt([1 1]*(df2p.*df2p))]);
cv2i = interp1(splen+.00001*(0:length(splen)-1),cv2, (0:(splen(end)-1)/(numcurvpts+1):(splen(end)-1)));

% calculate the curvature
df2 = diff(cv2i,1,1);
atdf2 =  unwrap(atan2(-df2(:,2), df2(:,1)));

curv = unwrap(diff(atdf2,1));
curv = transpose(curv);
end

function sortedSkel = sort_the_skel(skelPath,headPosition)
    D = bwdistgeodesic(skelPath,headPosition(1),headPosition(2));
    
    maxDist = max(D(:));
    sortedSkel = zeros(maxDist+1,2);
    for i = 1:maxDist+1
        [r, c] = find(D == i-1);
        sortedSkel(i,1) = r(1);
        sortedSkel(i,2) = c(1);
    end
    
end

function [skelPath,headPosition,tailPosition] = get_skel_for_one_frame(bwFish,headPosition)
    skel = bwmorph(bwFish,'thin',inf); % 10 is #operation
    headPosition = find_closest_point(skel,headPosition);
    D = bwdistgeodesic(skel,headPosition(1),headPosition(2));
    [tailY,tailX] = find(D == max(D(:)));
    tailPosition = [tailX, tailY];
    skelPath = get_skel(skel,headPosition,tailPosition);
end

function position = find_closest_point(BW,point)
    [y,x] = find(BW);
    dist = inf;
    for i = 1:length(y)
        tempDist = norm(abs([x(i),y(i)]-[point(1),point(2)]));
        if tempDist < dist
            dist = tempDist;
            position = [x(i),y(i)];
        end
    end
    
    
end

function skeleton_path = get_skel(skel,headPosition,tailPosition)
    
    c1 = headPosition(1);
    r1 = headPosition(2);
    c2 = tailPosition(1);
    r2 = tailPosition(2);
    
    D1 = bwdistgeodesic(skel, c1, r1, 'quasi-euclidean');
    D2 = bwdistgeodesic(skel, c2, r2, 'quasi-euclidean');

    D = D1 + D2;
    D = round(D * 8) / 8;
    D(isnan(D)) = inf;
    skeleton_path = imregionalmin(D);
end

function bwFish = get_bwFish(img)
    % extract fish from a noisy background in a video frame
    grayImg = rgb2gray(img);
    level = graythresh(grayImg);
    bw = im2bw(grayImg,0.6*level);
    bw2 = remove_white_on_boundary(bw);
    bw3 = remove_areas_not_in_range(bw2);
    bw4 = find_central_fish(bw3);
    bwFish = imfill(bw4,'holes');
end

function bw3 = remove_areas_not_in_range(bw)
    % set upbound and threshold to remove areas not fish
    threshold = 1000;
    upbound = 10000;
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
    if numArea == 1
        bw2 = bw;
    else
        centerOfImg = [size(bw,1)/2,size(bw,2)/2]; 
        centers = zeros(numArea,2);
        dists = zeros(numArea,1);
        areas = zeros(numArea,1);
        for n = 1:numArea
            [r,c] = find(L == n);
            areas(n) = length(r);
            centers(n,:) = [sum(r)/length(r),sum(c)/length(c)];
            dists(n) = norm(centers(n,:)-centerOfImg);
        end
        minIdx = find(dists == min(dists));
        bw2 = zeros(size(bw));
        indices = find(L == minIdx);
        bw2(indices) = 1;
    end
end

function [headPosition]=get_fish_head(bwFish)
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
        else
            headPosition = (bb(:,2) + bb(:,3))/2;
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
            
        else
            headPosition = (bb(:,4) + bb(:,3))/2;
            
        end
        
    end
    headPosition = floor(headPosition');
    
end

function [bendingPosition,bendingAngle]=calc_bendingAngle_and_bendingPosition(curv,sortedSkel)
    % first determine if it's a straight line
    
    numPoints = length(curv);
    minCurv = min(curv);
    maxCurv = max(curv);
    idxMin = find(curv == minCurv);
    idxMax = find(curv == maxCurv);
    
    idx = max(idxMin,idxMax);
    if idx > 0.6*numPoints
    bendingPosition = idx/numPoints;
    head2BP = sortedSkel(1,:) - sortedSkel(idx,:);
    BP2tail = sortedSkel(idx,:) - sortedSkel(end,:);
    bendingAngle = rad2deg(acos(head2BP*BP2tail'/norm(head2BP)/norm(BP2tail)));
    else
        bendingPosition = nan;
        bendingAngle = 0;
    end
    
    
end

function [isStraight,angle] = judge_straight_or_not(sortedSkel)
    headVec = sortedSkel(1,:) - sortedSkel(11,:);
    tailVec = sortedSkel(end-11,:) - sortedSkel(end,:);
    angle = acos(headVec*tailVec'/norm(headVec)/norm(tailVec));
    angle = rad2deg(angle);
    if angle < 15
        isStraight = 1;
    else
        isStraight = 0;
    end
    
    
end