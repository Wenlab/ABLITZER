function bwFish = extract_fish(grayImg)
    % extract fish from a noisy background in a video frame
    level = graythresh(grayImg);
    bw = im2bw(grayImg,0.6*level);
    %bw2 = remove_white_on_boundary(bw);
    %bw3 = remove_areas_not_in_range(bw2);
    se = strel('disk',10);
    bwDilate = imdilate(bw,se);
    bwFish = imerode(bwDilate,se);
    %bwFish = find_central_fish(bw3);
    
    
    
    %bwFish = imfill(bw4,'holes');
    
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

function bw3 = remove_areas_not_in_range(bw)
    % set upbound and threshold to remove areas not fish
    threshold = 1000;
    upbound = 10000;
    bw1 = bwareaopen(bw,threshold);
    bw2 = bwareaopen(bw,upbound);
    bw3 = bw1 - bw2;
    
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