function create_HUDS_video_from_rawVideo(expData,writeVideoFlag)
% since the rawVideo has no visual pattern in it, this code
% is to put the visual pattern on the raw video manually to 
% give viewer better experience to judge the performance in person.
[fVideo,pVideo] = uigetfile('*.avi'); % get video name
videoFileName = [pVideo,fVideo];

%% Read Video File
vObj = VideoReader(videoFileName);
height = vObj.Height;
width = vObj.Width;
X = [0,width,width,0];
numFrame = floor(vObj.Duration*vObj.FrameRate);
%% Write Video
newFileName = strcat(pVideo,'HUDS_',fVideo);
newVObj = VideoWriter(newFileName);
open(newVObj);


%% Get Experiment data from the struct
delimY = expData.DelimY;
patternIdx = expData.PatternIdx;
expPhase = expData.ExpPhase;
shockOnLeft = expData.ShockOnLeft;
shockOnRight = expData.ShockOnRight;

figure('visible','off');
clf;
%% Create new image with combined info from yaml and video
for i = 1:numFrame
    if mod(i,100) == 0
        fprintf('Frame: %d\n',i);
    end
    frame = readFrame(vObj);
    h = gcf;
    imshow(frame,[]);
    hold on;
    if patternIdx(i) == 0 
        Y = [0, 0, delimY, delimY];
        % Add red musk to the image
        fill(X,Y,'r','FaceAlpha',0.3);
    elseif patternIdx(i) == 1
        Y = [delimY, delimY, height, height];
        % Add red musk to the image
        fill(X,Y,'r','FaceAlpha',0.3);
    end
    
    % Tag the experiment phase
    if expPhase(i) == 0 % Baseline
        text(10,20,'Baseline','FontSize',15);
    elseif expPhase(i) == 1 % Training
        text(10,20,'Training','FontSize',15);
    elseif expPhase(i) == 2 % Blackout
        text(10,20,'Blackout','FontSize',15);
    elseif expPhase(i) == 3 % Test
        text(10,20,'Test','FontSize',15);
    end
    
    % Show if E-shock is given
    if shockOnLeft(i)
        text(10,40,'ShockOnLeft','FontSize',15);
    end
    
    if shockOnRight(i)
        text(500,40,'ShockOnRight','FontSize',15);
    end
    
    if writeVideoFlag
        F = getframe(h);
        writeVideo(newVObj,F.cdata);
    end
end



end
