
function [f_p_distance,f_p_angle] = calc_fish_para_distance_azimuth(showFlag)
 % Get bending position(normalized) and bending angle from low resolution fish video
    % Read video from file
    [filename,pathname]  = uigetfile({'*.avi'});
    fname=[pathname filename];
    vidObj=VideoReader(fname);
    
    % Initialize output variables
    numFrame = floor(vidObj.Duration*vidObj.FrameRate); % Convert double to int
    f_p_distance = zeros(numFrame,1);
    f_p_angle = zeros(numFrame,1);
    
    center=70;
    % Read frame one by one
    for i=1:numFrame
        fprintf('Frame: %d\n',i);
        img = readFrame(vidObj);% read next available frame
        bwFish = get_bwFish(img);%need
        headPosition = get_fish_head(bwFish);%need
        paraPosition = get_para_position(img);
        
         [skelPath,headPosition,tailPosition] = get_skel_for_one_frame(bwFish,headPosition);
         
         
        sortedSkel = sort_the_skel(skelPath,headPosition);
        
        body_line(1) = headPosition(1)-sortedSkel(center,2);
        body_line(2) = headPosition(2)-sortedSkel(center,1);
        head_para(1) = paraPosition(1)-headPosition(1);
        head_para(2) = paraPosition(2)-headPosition(2);
        
            
  
            
       
        if(paraPosition(1)==0&&paraPosition(2)==0)
            f_p_distance(i)=0;
            f_p_angle(i) = 0;
        else
            f_p_distance(i)=sqrt((headPosition(1)-paraPosition(1))^2+(headPosition(2)-paraPosition(2))^2);
            f_p_angle(i) = acos(dot(body_line,head_para)/(norm(body_line)*norm(head_para)))*180/pi;
        end
        
        
        if showFlag
            figure(1);
            imshow(img);
            hold on;
            scatter(headPosition(1),headPosition(2));
            scatter(paraPosition(1),paraPosition(2));
            scatter(sortedSkel(center,2),sortedSkel(center,1));
           % line([headPosition(1),headPosition(2)],[paraPosition(1),paraPosition(2)]);
            fprintf('f_p_distance: %f\n',f_p_distance(i));
            fprintf('f_p_angle: %f\n',f_p_angle(i));
           % pause(0.1);
            hold off;
        end
        
    end
   figure(2);
   x=0:1:numFrame-1;
       f_p_distance(134)=f_p_distance(133)/2;
       f_p_distance(47)=(f_p_distance(46)+f_p_distance(48))/2;
       f_p_distance(115)=(f_p_distance(114)+f_p_distance(116))/2;
         f_p_distance(119)=(f_p_distance(118)+f_p_distance(120))/2;
          f_p_distance(128)=(f_p_distance(127)+f_p_distance(129))/2;
       plot(x,f_p_distance);
       title('fish-para distance');
       xlabel('frame');
       ylabel('distance');
  figure(3);
   f_p_angle(134)=f_p_angle(133)/2;
       f_p_angle(47)=(f_p_angle(46)+f_p_angle(48))/2;
       f_p_angle(115)=(f_p_angle(114)+f_p_angle(116))/2;
         f_p_angle(119)=(f_p_angle(118)+f_p_angle(120))/2;
          f_p_angle(128)=(f_p_angle(127)+f_p_angle(129))/2;
  
    plot(x,f_p_angle);
     title('fish-para angle');
       xlabel('frame');
       ylabel('angle');
    
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

function [paraPosition]=get_para_position(img)
    a_gray=rgb2gray(img);
    BW=im2bw(a_gray,0.1);
    BW2 = bwareaopen(BW, 100);

    BW3=BW-BW2;

    BW4 = bwareaopen(BW3,45);

    for j =1:30
        for k= 1:30
            BW4(j,k)=0;
        end
        for k= 490:512
            BW4(j,k)=0;
        end
    end
    for j =490:512
        for k= 1:30
            BW4(j,k)=0;
        end
        for k= 490:512
            BW4(j,k)=0;
        end
    end

   % imshow(BW4);
    p = regionprops(BW4,'Centroid');
    if(norm(double(BW4),2)~=0)
    point=floor(p.Centroid);
    else 
        point=[0,0];
    end   
    paraPosition= point;
end

function [headPosition]=get_fish_head(bwFish)
    [yWhite,xWhite] = find(bwFish);
    P = [xWhite';yWhite'];
    bb = minBoundingBox(P); % 3rd party code
    
    % Get 2 regions of eyes
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