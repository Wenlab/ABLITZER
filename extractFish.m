function extractFish()

    [f,p] = uigetfile('*.avi');
    fName = [p,f];
    vobj = VideoReader(fName);
    for i = 1:200     % 200 frames as a simple
        frame = readFrame(vobj);
        grayImg = rgb2gray(frame);
        BW = imbinarize(grayImg,'adaptive','ForegroundPolarity','dark','Sensitivity',0.6);
        BW = bwareaopen(BW,10000);  % Remove objects in image containing fewer than 10000 pixels which often appear in the fish brain
        BW2 = BW*(-1)+1;
        bwFish1 = bwareaopen(BW2,50000); % Remove objects in image containing fewer than 50000 pixels
        bwFish2 = bwareaopen(bwFish1,80000);  % Remove the fish from image
        bwFish = bwFish1 - bwFish2;     % get the fish from image
        s = regionprops( bwFish,'centroid');
        centroids = cat(1, s.Centroid);
        figure(1);
        imshow(bwFish,[]);
        hold on;
        scatter(centroids(:,1),centroids(:,2),20,'b','filled');
        pause(0.1);

%% scatter the tail of the two fishes     
        [B,~] = bwboundaries(bwFish,'noholes');
        L = bwlabel(bwFish);   %get the points of two fishes
        [fish_x, fish_y] = find(L==1);
        fish = [fish_x,fish_y]';           
        C = B{1,1};
        tail = find_tail(C,fish);
        scatter(tail(2,1),tail(1,1),20,'r','o')
        pause(0.1);
        disp(i);
   end     
end     

%% function:get the point of tail
function head = find_tail(B,fish)
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
    f1_m = (f1+f2)./2;   f2_m = (f3+f4)./2;
    f3_m = (f2+f3)./2;   f4_m = (f4+f1)./2;
    [f_mid,D] = find_D(fish,f1_m,f2_m,f3_m,f4_m);
    D_norm = sqrt(D(1,:).^2+D(2,:).^2);
    min_D_norm = min(D_norm);
    idx = find(D_norm == min_D_norm);
    head = D(:,idx) + f_mid;
end

%% get a matrix of distance and f_mid
function  [f_mid,D] = find_D(fish,f1_m,f2_m,f3_m,f4_m)
    k = (f3_m(1,1) - f4_m(1,1))./(f3_m(2,1) - f4_m(2,1));
    b = f3_m(1,1) - k.*f3_m(2,1); 
    if f3_m(2,1) == f4_m(2,1)
        num1 = length(find(fish(2,:) - f3_m(2,1)<0));
        num2 = length(find(fish(2,:) - f3_m(2,1)>0));
        if num1 > num2
           if f1_m(2,1) > f2_m(2,1)
                f_mid = f1_m;    D = fish - f1_m;
           else
                f_mid = f2_m;   D = fish - f2_m;
           end
        else
           if  f1_m(2,1) < f2_m(2,1)
                f_mid = f1_m;    D = fish - f1_m;
           else
                f_mid = f2_m;    D = fish - f2_m;
           end
        end   
    else
        num1 = length(find(k.*fish(2,:)+b-fish(1,:)<0));
        num2 = length(find(k.*fish(2,:)+b-fish(1,:)>0));
        if num1 > num2
            if  f1_m(1,1) < f2_m(1,1)
                  f_mid = f1_m;    D = fish - f1_m;
            else
                  f_mid = f2_m;    D = fish - f2_m;
            end
        else
           if  f1_m(1,1) > f2_m(1,1)
                   f_mid = f1_m;   D = fish - f1_m;
           else
                   f_mid=f1_m;   D=fish-f2_m;
           end
        end
    end
      
end
