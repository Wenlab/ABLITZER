function make_free_moving_movie(img_stack,ratio,position,position_on_image,t)

[height,width]=size(img_stack(:,:,1));
h=height;
w=width;

xmin=min(position(:,1));
xmax=max(position(:,1));
ymin=min(position(:,2));
ymax=max(position(:,2));

r=(xmax-xmin+2000)/(ymax-ymin+2000);

hs=figure;
set(hs,'Units','pixels');
set(hs,'Position',[300 400 round((r*h*1.1+0.5*w)*1.1) round(1.1*h)]);
set(hs,'Renderer','zbuffer');


whitebg(hs);

cmap = colormap;

ratio_smooth = smooth(ratio,30);


max_r = max(ratio_smooth);
min_r = min(ratio_smooth);



lut = floor((ratio_smooth-min_r)/(max_r-min_r)*(length(cmap)-1));



numframes=length(ratio);

vidObj = VideoWriter('AIY.mp4','MPEG-4');
vidObj.FrameRate = 60;
open(vidObj);

t=t-t(1);



%set(gca,'nextplot','replacechildren');




axes1=subplot(1,2,1);
set(axes1, ...
    'Visible', 'off', ...
    'Units', 'pixels', ...
    'Position', [20 20 w/2 h],...
    'nextplot', 'replacechildren');


axes2=subplot(1,2,2);
bg_color=get(axes2,'Color');
set(axes2, ...
    'Visible', 'on', ...
    'Units', 'pixels', ...
    'Position', [w/2+20 20 floor(r*h*1.1) h],...
    'XLim',[xmin-1000 xmax+1000],...
    'Ylim',[ymin-1000 ymax+1000],...
    'nextplot', 'add',...
    'Box','off',...
    'XTick',[],...
    'YTick',[],...
    'ZTick',[],...
    'XColor',bg_color,...
    'YColor',bg_color,...
    'ZColor',bg_color,...
    'XLimMode','manual',...
    'YLimMode','manual');

colorbar; 
caxis([min_r max_r]);    
colormap(cmap);

    








 

for j=1:numframes
   
       
    img=img_stack(:,1:width/2,j);
    img=flipdim(img,1);
    img=flipdim(img,2);
    
    sec=t(j);
    minute=num2str(floor(sec/60));
    if length(minute)==1
        minute=strcat('0',minute);
    end
    
    second=num2str(floor(sec-floor(sec/60)*60));
    if length(second)==1
        second=strcat('0',second);
    end
    
    axes(axes1);
    imshow(img,[0 2000]);
    axis equal;
    hold on;
    text(10,10,strcat(minute,':',second));
    x=(width/2-position_on_image(j,1))+1;
    y=height-position_on_image(j,2)+1;
    hold on;
    rectangle('Position',[x-7, y-7, 14, 14],'EdgeColor','g');
    set(axes1,'nextplot','replacechildren');
    colormap(gray);
    freezeColors;
    
    axes(axes2);
    
    plot(position(j,1),position(j,2),'o','MarkerFaceColor',cmap(lut(j)+1,:),'MarkerEdgeColor',cmap(lut(j)+1,:),'MarkerSize',4);
    colormap(cmap);
    freezeColors;
    
    
    
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);
    
    
  
    
    
end

close(vidObj);
    
    
    


end



