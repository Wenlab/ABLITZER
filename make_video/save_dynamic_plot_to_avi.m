function save_dynamic_plot_to_avi(data,frameRate)
    aviname = input('input the file name for avi: ','s');
    aviobj=VideoWriter(aviname);
    aviobj.FrameRate=frameRate;
	open(aviobj);
	numFrames = length(data);
    for orderNum = 1:numFrames
        fig = plot_it_each_frame(data,orderNum);
        frame=getframe(fig);
        im=frame2im(frame);
        writeVideo(aviobj,im);
    end
	
	close(aviobj);
end

function fig = plot_it_each_frame(data,orderNum)
    %close all;
	fig=figure(1);
    
    
	numFrames = length(data);
	x = 1:orderNum;
	y = data(1:orderNum);
	plot(x,y,'w');
    set(gca,'color',[0 0 0]);
	yLow = 0;
	yHigh = 180;
    hold on;
    transitionPoint = 226;
    plot(transitionPoint*ones(size(yLow:yHigh)),yLow:yHigh,'b');
	axis([0 numFrames yLow yHigh]); % build up fixed x,y axises
    title('Convergence Angle'); % Bending Angle of Tail % Convergence Angle
    xlabel('t/frame');
    ylabel('angle/degrees');
    hold off;
    pause(0.1);
	
end



