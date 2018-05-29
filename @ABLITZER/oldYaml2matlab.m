function oldYaml2matlab(obj, endFrame, pathName, fileName)
    MaxFrames = 100000; % the max number of frames

    if (nargin == 4)
        if endFrame == -1
            endFrame = inf;
        end
    elseif (nargin == 2)
        [fileName,pathName] = uigetfile('*yaml');
    elseif (nargin == 1)
        [fileName,pathName] = uigetfile('*yaml');
        endFrame = inf;
    else
        error('Wrong number of input arguments');
    end
    
    % Extract fish's IDs, ages, strains and task from fileName
    % Different infos are separated by "_"
    fName = [pathName, fileName];
    
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
    fishStrains = [string(fishStrain1), string(fishStrain2)];
    task = fileName(idx(5)+1:end-5);
    
    
    
    fid = fopen(fName);
    
    ifReached = false; % logical value
    while (~ifReached && ~feof(fid))
        disp('Reading the general experimental info');
        [key, value] = read_a_line(fid);
        if (~isempty(key))
            switch key
                case 'FishIDs'
                    fishIDs = str2num(value);
                case 'FishAges'
                    fishAges = str2num(value);
                case 'Task'
                    task = string(value);
                case 'FishStrains'
                    fishStrains = str2num(value);    
                case 'ExpStartTime'
                    expStartTime = value;
                case 'FrameRate'
                    frameRate = str2num(value);
                case 'FrameSize'
                    frameSize = str2num(value);
                case 'DelimX'
                    delimX = str2num(value);
                case 'DelimY' % Historical wrong nomination
                    yDivide = str2num(value);   
                case 'Frames'
                    ifReached = true;
                otherwise
                    disp(['Unrecognized keyword: ', key]);
            end
        end
    end
    
    numFish = 2;
    F(numFish) = FISHDATA;
    % read frames until the end

    frames(MaxFrames,numFish) = FRAMEDATA;
    idxFrame = 1;
    idxFish = 1;
    
    while (~feof(fid))
        [key, value] = read_a_line(fid);
        if (~isempty(key))
            switch key
                case 'Frames'
                    idxFrame = idxFrame + 1;
                    % show the progress
                    if (mod(idxFrame,100)==0)
                        disp(idxFrame);
                    end
                    if (idxFrame > endFrame)
                        break;
                    end
                case 'FrameNum'
                    for i = 1:numFish
                        frames(idxFrame,i).FrameNum = str2num(value);
                    end
                case 'ExpPhase'
                    for i = 1:numFish
                        frames(idxFrame,i).ExpPhase = str2num(value);
                    end
                case 'sElapsed'
                    sElapsed = str2num(value);
                case 'msRemElapsed'
                    msRemElapsed = str2num(value);
                    for i = 1:numFish
                        frames(idxFrame,i).TimeElapsed = sElapsed ...
                            +  msRemElapsed / 1000;
                    end
                    % First fish on the left
                case 'Head1'
                    frames(idxFrame,1).Head = str2num(value);
                case 'Tail1'
                    frames(idxFrame,1).Tail = str2num(value);
                case 'Center1'
                    frames(idxFrame,1).Center = str2num(value);
                case 'HeadingAngle1'
                    frames(idxFrame,1).HeadingAngle = str2num(value);
                case 'ShockOnLeft'
                    frames(idxFrame,1).ShockOn = str2num(value);
                case 'PatternIdx1'
                    frames(idxFrame,1).PatternIdx = str2num(value);
                    % Second fish on the right
                case 'Head2'
                    frames(idxFrame,2).Head = str2num(value);
                case 'Tail2'
                    frames(idxFrame,2).Tail = str2num(value);
                case 'Center2'
                    frames(idxFrame,2).Center = str2num(value);
                case 'HeadingAngle2'
                    frames(idxFrame,2).HeadingAngle = str2num(value);
                case 'ShockOnRight'
                    frames(idxFrame,2).ShockOn = str2num(value);
                case 'PatternIdx2'
                    frames(idxFrame,2).PatternIdx = str2num(value);
             otherwise
                    disp(['Unrecognized keyword: ', key]);
            end
        end
    end

frames(idxFrame:end,:) = []; % remove redundant frames
    
    
    % Assign values to the object of ABLITZER
    for i = 1:numFish
        F(i).Frames = frames(:,i);
        F(i).ID = fishIDs(i);
        age = char(fishAges(i));
        F(i).Age = str2num(age(1));
        F(i).Strain = fishStrains(i);
        F(i).ExpTask = task;
        
        F(i).ExpStartTime = expStartTime;
        F(i).FrameRate = frameRate;
        F(i).yDivide = yDivide;
%         Scheme for fish positions in arena
%               xCut
%         |		|		|
%         |	0	|	1	|
%         |		|		|
%         |-------------| yCut
%         |		|		|
%         |	2	|	3	|
%         |		|		|
        if (i==1) % topLeft_x, topLeft_y, width, height
            F(i).ConfinedRect = [0,0,delimX,frameSize(2)]; 
        elseif (i==2)
            F(i).ConfinedRect = [delimX,0,frameSize(1)-delimX,frameSize(2)]; 
        end
        
        if contains(task,'control','IgnoreCase',true)
            F(i).ExpType = "Control Group";
        elseif contains(task,'exp','IgnoreCase',true)
            F(i).ExpType = "Exp Group";
        else
            F(i).ExpType = "Unrecognized";
        end
        
        obj.FishStack = cat(1,obj.FishStack,F(i));
        
    end




end

function [key, value] = read_a_line(fid)
% read a line in yaml and convert the value to struct
% if it is a key-value pair.
tline = fgets(fid);
newLine = remove_brackets(tline);
if (contains(newLine,":"))
    [key,value] = readKeyValuePair(newLine);
else
    key = [];
    value = [];
end

end

function newLine = remove_brackets(tline)
    startIdx = strfind(tline,"{");
    if isempty(startIdx)
        newLine = tline;
        return
    else
        endIdx = strfind(tline,"}");
        newLine = tline(startIdx+1:endIdx-1);
    end
    

end

function [fieldName,value] = readKeyValuePair(str)
    q=textscan(str,'%q','Delimiter',':');
    fieldName = q{1}{1};
    if (length(q{1}) >= 2)
        value = q{1}{2};
    else
        value = [];
    end
end

% Extract fish's IDs, ages, strains and task from fileName
% Different infos are separated by "_"
function extract_expInfo_from_filename(obj)
    
    idx = find(obj.FileName == '_');
    FishID1 = obj.FileName(idx(1)+1:idx(2)-1);
    if (contains(FishID1,'G'))
        FishStrain1 = 'GCaMP';
    elseif (contains(FishID1,'S'))
        FishStrain1 = 'WT';
    end
    FishID2 = obj.FileName(idx(3)+1:idx(4)-1);
    if (contains(FishID2,'G'))
        FishStrain2 = 'GCaMP';
    elseif (contains(FishID2,'S'))
        FishStrain2 = 'WT';
    end
    
    Age1 = obj.FileName(idx(2)+1:idx(3)-1);
    Age2 = obj.FileName(idx(4)+1:idx(5)-1);
    
    obj.Task = obj.FileName(idx(5)+1:end-5);
    obj.FishIDs = [string(FishID1), string(FishID2)];
    obj.FishAges = [string(Age1), string(Age2)];
    obj.FishStrains = [string(FishStrain1), string(FishStrain2)];
    

end