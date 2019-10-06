function [head,centroid,tail,angle] = getDataFromFreeSwim()
    % angle: vector "head-centroids" and vector "centroids-tail"
    ...centroids: the centroid of swimming bladder
    ...head: the midpoint of two eyes
    ...tail: 9/10 tail
    [f,p] = uigetfile('*.avi');
    fName = [p,f];
    v0bj = VideoReader(fName);
    numFrame = 5000;
    BgFrame = 400;
    n = 0;
    ImgStack = zeros(v0bj.Height,v0bj.Width,BgFrame);
 %   angle = zeros(n,1);
    %% get the first two hundred ImgStack
for i = 1:BgFrame                 
    frame = readFrame(v0bj);       % read one frame from vObj
    grayImg = rgb2gray(frame)./100;
    ImgStack(:,:,i) = grayImg;
end
%% updata mean background image,get and imshow bwfish
for i = BgFrame+1:numFrame         
     n = n+1;         %meaningless,used for counting   
     frame = readFrame(v0bj);
     grayImg = rgb2gray(frame)./100;
     [meanBg,ImgStack] = update_meanBg(grayImg,ImgStack); 
     frontImg = double(grayImg) - meanBg;     %get frontImg
                             %Convert image to binary image
     idx = find(frontImg<0);      
     frontImg(idx)=0;
    
      BW = imbinarize(frontImg,0.2);
 
 
 
    
     %   frame = readFrame(vobj);
      %  grayImg = rgb2gray(frame);
       % BW = imbinarize(grayImg,'adaptive','ForegroundPolarity','dark','Sensitivity',0.85);
        bwFish = bwareaopen(BW,1100);  % Remove objects in image containing fewer than 1100 pixels which often appear in the fish brain
        s = regionprops( bwFish,'centroid');
        centroid_raw = s.Centroid';
       
        [B,~] = bwboundaries(bwFish,'noholes');
        L = bwlabel(bwFish);   %get the points of fish
        [fish_y, fish_x] = find(L==1);
        fish = [fish_y,fish_x]';
        C = B{1,1};
        P=C';
        D=[];
        D(1,:)=P(2,:);
         D(2,:)=P(1,:);
        [tail_raw,head_raw] = findRawTailHead(C,fish);
        centroid(:,i) = centroid_raw;
    %    centroid(:,i) = head_raw*(1/4)+centroid_raw*(3/4);   % centroids: the centroid of swimming bladder
        head(:,i) = head_raw*(3/4)+centroid_raw*(1/4);      % head: the midpoint of two eyes
             
        tailAxis = tail_raw - centroid(:,i);
        
        Pointa=[tailAxis(1); -tailAxis(2)];
        Pointb=[-tailAxis(1); tailAxis(2)];
        tailPt_a = centroid(:,i) + tailAxis * 9 / 10 + Pointa/4;
	    tailPt_b = centroid(:,i) + tailAxis * 9 / 10 + Pointb/4;
        d = [];
       for t = 1:length(D)
           d(t) = abs(det([tailPt_a-tailPt_b,D(:,t)-tailPt_a]))/norm(tailPt_a-tailPt_b);
       end
       idx = find(d<1);
       Y=[];
      
       Y = D(:,idx);
       d1=[];
       d2=[];
       for t = 1:length(idx)
           d1(t) = norm(tailPt_a(1)-Y(1,t));
           d2(t) = norm(tailPt_b(1)-Y(1,t));
       end
       [~,idx1]=min(d1);
       [~,idx2]=min(d2);
       tail(:,i) = (Y(:,idx1(1))+Y(:,idx2(1)))/2;
        figure(1);
        pause(0.1);
        imshow(bwFish,[]);
        hold on; 
      %% scatter tail,head,center
        scatter(tailPt_a(1,1),tailPt_a(2,1),20,'r','filled') 
        
        scatter(tailPt_b(1,1),tailPt_b(2,1),20,'r','filled') 
        scatter(tail(1,i),tail(2,i),20,'r','filled') 
        scatter(head(1,i),head(2,i),20,'y','filled')
       
       
        scatter(centroid(1,i),centroid(2,i),20,'b','filled');
        pause(0.1);
      %% get the alpha of [center-tail] and [head-center];
        a = centroid(:,i) - head(:,i);
        b = tail(:,i) - centroid(:,i);
        cos = (a(1,1)*b(1,1)+a(2,1)*b(2,1))/(norm(a)*norm(b));
        
        if tail(1,i) < head(1,i)   % left-negative     right-positive
            angle(i) = -abs(acos(cos)/pi*180);
        else
            angle(i) = abs(acos(cos)/pi*180);
        end
        disp(i);

end
  
end

%% function: updata mean background image 
function [meanBg,ImgStack]=update_meanBg(grayImg,ImgStack)
    ImgStack(:,:,1)=[];
    ImgStack=cat(3,ImgStack,grayImg);
    meanBg=mean(ImgStack,3);
end

%% function:get the point of raw tail and head
function [tail,head] = findRawTailHead(B,fish)
    c = minBoundingBox(B');
    C = zeros(2,1);
    C(1) = norm(c(:,1) - c(:,2));
    C(2) = norm(c(:,1) - c(:,4));
    min_norm_c = min(C);
    if min_norm_c == C(1)
        f1 = c(:,1);  f2 = c(:,2);  f3 = c(:,3);  f4 = c(:,4);
    else
        f1 = c(:,2);  f2 = c(:,3);  f3 = c(:,4);  f4 = c(:,1);
    end
    midPoint = [(f1+f2)./2,(f3+f4)./2,(f2+f3)./2,(f4+f1)./2];
    [tail_midPoint,tail_D,head_midPoint,head_D] = findMidpointandDistance(fish,midPoint);
    tail = getCoordinate(tail_midPoint,tail_D);
    head = getCoordinate(head_midPoint,head_D);
end

%% get a matrix of distance between the points of fish and midpoint and midpoint of the edge of the rectangle closest to the tail
function  [tail_midPoint,tail_D,head_midPoint,head_D] = findMidpointandDistance(fish,midPoint)
  % tail(head)_midPoint is the midpoint of the edge of the rectangle closest to the tail
  % D_tail(head) is a matrix of distance between the points of fish and midpoint
    k = (midPoint(1,3) - midPoint(1,4))./(midPoint(2,3) - midPoint(2,4));
    b = midPoint(1,3) - k.*midPoint(2,3);
    if midPoint(2,3) == midPoint(2,4)
        num1 = length(find(fish(2,:) - midPoint(2,3)<0));
        num2 = length(find(fish(2,:) - midPoint(2,3)>0));
        if num1 > num2
           if midPoint(2,1) > midPoint(2,2)
                tail_midPoint = midPoint(:,1);    tail_D = fish - midPoint(:,1);
           else
                tail_midPoint = midPoint(:,2);    tail_D = fish - midPoint(:,2);
           end
        else
           if midPoint(2,1) < midPoint(2,2)
                tail_midPoint = midPoint(:,1);    tail_D = fish - midPoint(:,1);
           else
                tail_midPoint = midPoint(:,2);    tail_D = fish - midPoint(:,2);
           end
        end
    else
        num1 = length(find(k.*fish(2,:)+b-fish(1,:)<0));
        num2 = length(find(k.*fish(2,:)+b-fish(1,:)>0));
        if num1 > num2
          if  midPoint(1,1) < midPoint(1,2)
                tail_midPoint = midPoint(:,1);    tail_D = fish - midPoint(:,1);
          else
                tail_midPoint = midPoint(:,2);    tail_D = fish - midPoint(:,2);
          end
        else
          if  midPoint(1,1) > midPoint(1,2)
                tail_midPoint = midPoint(:,1);    tail_D = fish - midPoint(:,1);
          else
                tail_midPoint = midPoint(:,2);    tail_D = fish - midPoint(:,2);
          end
        end
    end
    if tail_midPoint == midPoint(:,1)
         head_midPoint = midPoint(:,2);    head_D = fish - midPoint(:,2);
    else
         head_midPoint = midPoint(:,1);    head_D = fish - midPoint(:,1);
    end
end

%% get the coordinate of tail or head
function Coordinate = getCoordinate(midPoint,D)
    D_norm = sqrt(D(1,:).^2+D(2,:).^2);
    min_D_norm = min(D_norm);
    idx = find(D_norm == min_D_norm);
    Coordinate_raw = D(:,idx(1)) + midPoint;
    Coordinate(1,:)=Coordinate_raw(2,:);
    Coordinate(2,:)=Coordinate_raw(1,:);
end
