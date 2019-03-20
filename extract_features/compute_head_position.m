function [head_end_position,head_tip_position,true_orientation]=compute_head_position(bw,head_orientation_prior)    

    D=bwdist(~bw);
    
    [~,idx]=max(D(:));

    [I,J]=ind2sub(size(D),idx);
    head=[I,J];
    

    
    %the orientation of the head in the previous frame
    %this can be used as a prior for the current frame

    STATS = regionprops(logical(bw),'Area', 'Orientation');
    
    if size(STATS,1) == 0 
        disp('Error: no fish found');
        return;
    end
    
    num=1;
    
    area=0;

    if (length(STATS)>=1)
        for k=1:length(STATS)
            if STATS(k).Area>area
                area=STATS(k).Area;
                %the calculated orientation ranges from -pi/2 to pi/2
                head_orientation=STATS(k).Orientation*pi/180; 
                num=k;
            end
        end
    end
    
    
   
    
    
    
    
    
    [B,~] = bwboundaries(bw,'noholes');
    
    
    B1 = B{num};
    B1_size = size(B1,1);    
    B2=B1-repmat(head,B1_size,1);
   

    
    %relative orientation between head centroid and boundary points
    %ranging from -pi to pi, y axis is inverted for image display
       
    bpts_orientation=angle(B2(:,2)-sqrt(-1)*B2(:,1));
    
    %the normal vector of boundary points relative to the head centroid
    t2=[cos(bpts_orientation) sin(bpts_orientation)];
    
    %the normal vector of head orientation
    t1=repmat([cos(head_orientation) sin(head_orientation)],B1_size,1);
    
    %dot product calculate the angle between the two vectors
    cos_theta=dot(t1,t2,2);
    sin_theta=sqrt(1-cos_theta.^2);
    
    d=sqrt((B2(:,1).^2+B2(:,2).^2)).*sin_theta;

    diffs_prior=abs(bpts_orientation-head_orientation_prior);
    
    [~,idx]=sort(d); %acending order
    
   % for j=1:B1_size
   %     if ((diffs_prior(idx(j)))>pi/3)
   %         head_idx=idx(j);
    %        head_end_position=B1(head_idx,:);
     %       true_orientation=bpts_orientation(head_idx);
 
      %     break;
          
       % end
   
  %  end
    
    
    
    for j=1:B1_size
        if ((diffs_prior(idx(j)))<pi/3)
            head_idx=idx(j);
            head_tip_position=B1(head_idx,:);
            true_orientation=bpts_orientation(head_idx);
    
            break;
        end
   
    end
            
   for j=1:B1_size
        if ((diffs_prior(idx(j)))>pi/3)
            head_idx=idx(j);
            head_end_position=B1(head_idx,:);
    
            break;
        end
   
    end
       
    
    
    
    %for j=1:B1_size
        
        
            
    %        if ((bpts_orientation(j) > pi/2))
    %            diffs(j) = abs(bpts_orientation(j)-pi-head_orientation);
                
    %        elseif (bpts_orientation(j) < -pi/2)
                
    %            diffs(j) = abs(bpts_orientation(j)+pi-head_orientation);
                
    %        else
                
    %            diffs(j) = abs(bpts_orientation(j)-head_orientation);
    %        end  
        
    %end
    
    
    
end
    
    
    
    