% TODO: add a GUI for reading video
% TODO: add press esc to quit
function annotateRawVideo_cut(expData)
%% Read Video File
% what does this "cut" mean?
  
   [f,p] = uigetfile('*.avi');
   videoName = [p,f];

   vObj = VideoReader(videoName);
%% Write Video
 

for i=2000:4000
    if ~hasFrame(vObj)
        return;
    end
    if (mod(i,10) == 0)
        disp(i);
    end
    img = readFrame(vObj);
    
   
     imshow(img,[]);
    hold on;

%%  
        
        if (expData.PatternIdx2(i) == 0)
            text(35,10, 'CS TOP');
        elseif (expData.PatternIdx2(i) == 1)
            text(35, 10, 'CS BOTTOM');  
        end
        line([0,350],[210,210],'color','r');
%%        
   

end
  
        
  
       
end

