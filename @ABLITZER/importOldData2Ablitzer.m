% import old data expData and resData to new data structure ABLITZER
% do not import res, re-analyze the experiment data with new code
function importOldData2Ablitzer(obj, pathName, fileName)
   
    if (nargin == 1)
        [fileName,pathName] = uigetfile('*.mat');
    elseif (nargin == 3)
        disp('FileName supplied in the argument list');
    else
        error('Wrong number of input arguments');
    end
    
    fName = [pathName, fileName];
    load(fName,'expData','res');
    
    numFrames = length(expData.ShockOnRight); % the max number of frames
    numFish = 2;
    F(numFish) = FISHDATA;
    
    % Assign frames data from the expdata
    frames(numFrames,numFish) = FRAMEDATA;
    % Assign values to the object of ABLITZER
    for i = 1:numFish
        for j = 1:numFrames
            frames(j,i).FrameNum = expData.FrameNum(j);
            frames(j,i).ExpPhase = expData.ExpPhase(j);
            frames(j,i).TimeElapsed = expData.TimeElapsed(j);
            if (i == 1) % first fish
                frames(j,i).Head = expData.Head1(j,:);
                frames(j,i).Tail = expData.Tail1(j,:);
                frames(j,i).Center = expData.Center1(j,:);
                frames(j,i).HeadingAngle = expData.HeadingAngle1(j);
                frames(j,i).PatternIdx = expData.PatternIdx1(j);
                frames(j,i).ShockOn = expData.ShockOnLeft(j);
                
            elseif (i == 2) % second fish
                frames(j,i).Head = expData.Head2(j,:);
                frames(j,i).Tail = expData.Tail2(j,:);
                frames(j,i).Center = expData.Center2(j,:);
                frames(j,i).HeadingAngle = expData.HeadingAngle2(j);
                frames(j,i).PatternIdx = expData.PatternIdx2(j);
                frames(j,i).ShockOn = expData.ShockOnRight(j);
            end
        end
       
        
        
        
        
        F(i).ExpStartTime = expData.ExpStartTime;
        F(i).ExpTask = string(expData.Task);
        if contains(task,'control','IgnoreCase',true)
            F(i).ExpType = "Control Group";
        elseif contains(task,'exp','IgnoreCase',true)
            F(i).ExpType = "Exp Group";
        else
            F(i).ExpType = "Unrecognized";
        end
        F(i).FrameRate = expData.FrameRate;
        F(i).yDivide = expData.DelimY;
        
        
        if (i == 1) % first fish
            
            
            F(i).ID = expData.FishID1;
            if (contains(F(i).ID,'G'))
                F(i).Strain = "GCaMP";
            elseif (contains(F(i).ID,'S'))
                F(i).Strain = "WT";
            end
            fishAge = expData.Age1;
            F(i).Age = fishAge(1); % take the 1st char
            F(i).ConfinedRect = [0, 0, expData.DelimX, expData.FrameSize(2)];
            F(i).Frames = frames(:,i);
        elseif (i==2) % second fish
            F(i).ID = expData.FishID2;
            if (contains(F(i).ID,'G'))
                F(i).Strain = "GCaMP";
            elseif (contains(F(i).ID,'S'))
                F(i).Strain = "WT";
            end
            fishAge = expData.Age2;
            F(i).Age = fishAge(1); % take the 1st char
            F(i).ConfinedRect = [expData.DelimX, 0, expData.FrameSize(1), expData.FrameSize(2)];
            F(i).Frames = frames(:,i);
        end
        
        obj.FishStack = cat(1,obj.FishStack,F(i));
    end
    
    





end