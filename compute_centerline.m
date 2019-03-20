function [midline_mixed,path1_rescaled,path2_rescaled,tail_position]=compute_centerline(img_bw_head,bw,head_position,headbacktip_position)

    %bw = imclose(img_bw,strel('disk',10));
    STATS = regionprops(logical(bw),'Area');
    
    if size(STATS,1) == 0 
        disp('Error: no worm found');
        return;
    end
    
    num=1;
    
    area=0;

    if (length(STATS)>=1)
        for k=1:length(STATS)
            if STATS(k).Area>area
                area=STATS(k).Area;
                num=k;
            end
        end
    end
    
    %{
    [B,~] = bwboundaries(bw,'noholes');
    
    
    B1 = B{num};
    
    B1_size=size(B1,1);
    
    B2=repmat(head_position,B1_size,1)-B1;

    
    diff_distances=sqrt(sum(B2.^2,2));
    
    [~,head_idx]=min(diff_distances);
    
    
%}
    
    %return;
    %head_props = regionprops(img_bw_head,'Orientation');
   % se_line = translate(strel('line',20,head_props(num).Orientation+90),round(headbacktip_position/2));

    %img_line = getnhood(se_line);
    %img_line(size(bw,1),size(bw,2))=0;
    %[head_section_points(:,1),head_section_points(:,2)] = find(bwmorph(img_line|bwmorph(bw,'remove'),'branchpoints')==1);

    B_whole = bwboundaries(bw);
    B_whole = B_whole{1};
    
   
    
    v_backtip_B = B_whole - repmat(headbacktip_position,[size(B_whole,1),1]); 
    circle_points_idx = find(sqrt(v_backtip_B(:,1).^2+v_backtip_B(:,2).^2)<20);
    
    head_orientation_vector = head_position-headbacktip_position;
    head_orientation_vector = head_orientation_vector./norm(head_orientation_vector);
    
    %[sin(head_props(num).Orientation*pi/180),cos(head_props(num).Orientation*pi/180)];
    sin_B_orient = (v_backtip_B(:,2)*head_orientation_vector(:,1)-v_backtip_B(:,1)*head_orientation_vector(:,2))./sqrt(v_backtip_B(:,1).^2+v_backtip_B(:,2).^2);
    
    tmp1 = abs(sin_B_orient-1);
    tmp2 = abs(sin_B_orient+1);
    
    [tmp_idx1,~] = find(tmp1(circle_points_idx)==min(min(tmp1(circle_points_idx))));
    [tmp_idx2,~] = find(tmp2(circle_points_idx)==min(min(tmp2(circle_points_idx))));
    
    tmp_idx1 = circle_points_idx(tmp_idx1(1));
    tmp_idx2 = circle_points_idx(tmp_idx2(1));
    %tmp_idx = find(B_whole(:,1)==head_section_points(1,1) & B_whole(:,2)==head_section_points(1,2));
    B_whole = circshift(B_whole,[1-tmp_idx1,0]);
   % section_point_idx = find(B_whole(:,1)==head_section_points(2,1) & B_whole(:,2)==head_section_points(2,2));

    tmp_idx2 = mod(tmp_idx2+1-tmp_idx1,size(B_whole,1));
    
    B_diff_head = B_whole - repmat(head_position,size(B_whole,1),1);
    B_diff_head = B_diff_head(:,1).^2+B_diff_head(:,2).^2;
    
    if min(B_diff_head(1:tmp_idx2))>min(B_diff_head((tmp_idx2+1):end))
        B1 = B_whole(1:tmp_idx2,:);
    else
        B_whole = circshift(B_whole,[1-tmp_idx2,0]);
        B1 = B_whole(1:size(B_whole,1)-tmp_idx2+2,:);
    end

    %B1 is the tail boundaries.
    B1_size = size(B1,1);
    
    ksep = ceil(B1_size/40);
    
    B1_plus = circshift(B1,[ksep 0]);
    B1_minus = circshift(B1,[-ksep 0]);

    AA = B1 - B1_plus;  % AA and BB are vectors between a point on boundary and neighbors +- ksep away
    BB = B1 - B1_minus;

    
    
    %cAA = AA(:,1) + sqrt(-1)*AA(:,2);
    %cBB = BB(:,1) + sqrt(-1)*BB(:,2);

    %B1_angle_sin = unwrap(angle(cBB ./ cAA));
    B1_angle_cos = (AA(:,1).*BB(:,1)+AA(:,2).*BB(:,2))./sqrt(AA(:,1).^2+AA(:,2).^2)./sqrt(BB(:,1).^2+BB(:,2).^2);


    [~,tail_idx] = max(B1_angle_cos((ksep+1):B1_size-ksep)); % find point on boundary w/ minimum angle between AA, BB
    tail_idx = tail_idx + ksep;
    
    tail_position=B1(tail_idx,:);
    %B1_angle2 = circshift(B1_angle, -min1);
    %min2a = round(.25*B1_size)-1+find(B1_angle2(round(.25*B1_size):round(0.75*B1_size))==min(B1_angle2(round(.25*B1_size):round(0.75*B1_size))),1);  % find minimum in other half
    %min2 = 1+mod(min2a + min1-1, B1_size);
    
    %tmp = circshift(B1, [1-head_idx 0]);
    %end1 = 1+mod(tail_idx-head_idx-1, B1_size);
    %path1 = tmp(1:end1,:);
    %path2 = tmp(end:-1:end1,:);

    path1 = B1(1:tail_idx -1,:);
    path2 = flip(B1(tail_idx+1:end,:));
    
    %if norm(path1(1,:) - [heady headx]) > norm(path1(end,:) - [heady headx]) % if min1 is at tail, reverse both paths
    %    tmp = path1;
    %    path1 = path2(end:-1:1,:);
    %    path2 = tmp(end:-1:1,:);
    %end
    
    %heady = path1(1,1);
    %headx = path1(1,2);
    
    path_length = 100;
    numcurvpts=100;

    path1_rescaled = zeros(path_length,2);
    path2_rescaled = zeros(path_length,2);
    path1_rescaled2 = zeros(path_length,2);
    path2_rescaled2 = zeros(path_length,2);
    
    path1_rescaled(:,1) = interp1(0:size(path1,1)-1, path1(:,1), (size(path1,1)-1)*(0:path_length-1)/(path_length-1), 'linear');
    path1_rescaled(:,2) = interp1(0:size(path1,1)-1, path1(:,2), (size(path1,1)-1)*(0:path_length-1)/(path_length-1), 'linear');
    path2_rescaled(:,1) = interp1(0:size(path2,1)-1, path2(:,1), (size(path2,1)-1)*(0:path_length-1)/(path_length-1), 'linear');
    path2_rescaled(:,2) = interp1(0:size(path2,1)-1, path2(:,2), (size(path2,1)-1)*(0:path_length-1)/(path_length-1), 'linear');

    for kk=1:path_length
        tmp1 = repmat(path1_rescaled(kk,:), [path_length,1]) - path2_rescaled;
        tmp2 = sqrt(tmp1(:,1).^2 + tmp1(:,2).^2);
        path2_rescaled2(kk,:) = path2_rescaled(find(tmp2==min(tmp2),1),:);
    end

%     path1_rescaled2 = path1_rescaled;
    for kk=1:path_length
        tmp1 = repmat(path2_rescaled(kk,:), [path_length,1]) - path1_rescaled;
        tmp2 = sqrt(tmp1(:,1).^2 + tmp1(:,2).^2);
%         find(tmp2==min(tmp2),1)
        path1_rescaled2(kk,:) = path1_rescaled(find(tmp2==min(tmp2),1),:);
    end
    
    %{
    weight_fn = ones(path_length,1);
    tmp=round(path_length*0.2);
    weight_fn(1:tmp)=(0:tmp-1)/tmp;
    weight_fn(end-tmp+1:end)=(tmp-1:-1:0)/tmp;
    weight_fn_new = [weight_fn weight_fn];
    
    
    midline = 0.5*(path1_rescaled+path2_rescaled);
    midline2a = 0.5*(path1_rescaled+path2_rescaled2);
    midline2b = 0.5*(path1_rescaled2+path2_rescaled);
    midline_mixed = midline2a .* weight_fn_new + midline .* (1-weight_fn_new);
    %}
    tmp = headbacktip_position - head_position;
    head_centerline_points = repmat(head_position,[20,1]) + [(1:20)/20*tmp(1,1);(1:20)/20*tmp(1,2)]';
    %[headbacktip_position(1):tmp(1)/20:head_position(1);headbacktip_position(2):tmp(2)/20:head_position(2)]';
    
    
    midline_mixed =[head_centerline_points(1:end-1,:);.25*(path1_rescaled+path2_rescaled)+.25*(path1_rescaled2+path2_rescaled2)];