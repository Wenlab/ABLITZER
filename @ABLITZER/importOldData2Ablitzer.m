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
    
    idx = find(fileName == '_');
    fishID1 = fileName(idx(1)+1:idx(2)-1);
    if (contains(fishID1,'G'))
        fishStrain1 = "GCaMP";
    elseif (contains(fishID1,'S'))
        fishStrain1 = "WT";
    end
    
    fishID2 = fileName(idx(3)+1:idx(4)-1);
    if (contains(fishID2,'G'))
        fishStrain2 = "GCaMP";
    elseif (contains(fishID2,'S'))
        fishStrain2 = "WT";
    end
    
    fishAge1 = fileName(idx(2)+1:idx(3)-1);
    fishAge2 = fileName(idx(4)+1:idx(5)-1);
    
    fishIDs = [string(fishID1),string(fishID2)];
    fishAges = [string(fishAge1), string(fishAge2)];
    %fishStrains = [string(fishStrain1), string(fishStrain2)];
    task = fileName(idx(5)+1:end-4);
    
    
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
        F(i).ExpTask = string(task);
        if contains(F(i).ExpTask,'control','IgnoreCase',true)
            F(i).ExpType = "Control Group";
        elseif contains(F(i).ExpTask,'exp','IgnoreCase',true)
            F(i).ExpType = "Exp Group";
        else
            F(i).ExpType = "Unrecognized";
        end
        F(i).FrameRate = expData.FrameRate;
        F(i).yDivide = expData.DelimY;
        
        
        if (i == 1) % first fish
            
            
            F(i).ID = fishIDs(1);
            if (contains(F(i).ID,'G'))
                F(i).Strain = "GCaMP";
            elseif (contains(F(i).ID,'S'))
                F(i).Strain = "WT";
            end
            fishAge = char(fishAges(i));
            F(i).Age = str2num(fishAge(1)); % take the 1st char
            F(i).ConfinedRect = [0, 0, expData.DelimX, expData.FrameSize(2)];
            F(i).Frames = frames(:,i);
        elseif (i==2) % second fish
            F(i).ID = fishIDs(1);
            if (contains(F(i).ID,'G'))
                F(i).Strain = "GCaMP";
            elseif (contains(F(i).ID,'S'))
                F(i).Strain = "WT";
            end
            fishAge = char(fishAges(i));
            F(i).Age = str2num(fishAge(1)); % take the 1st char
            F(i).ConfinedRect = [expData.DelimX, 0, expData.FrameSize(1), expData.FrameSize(2)];
            F(i).Frames = frames(:,i);
        end
        
        obj.FishStack = cat(1,obj.FishStack,F(i));
    end
    
    





end