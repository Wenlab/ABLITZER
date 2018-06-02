%   Copyright 2018 Wenbin Yang <bysin7@gmail.com>
%   This file is part of A-BLITZ-ER[1] (Analyzer of Behavioral Learning 
%   In The ZEbrafish Result.) i.e. the analyzer of BLITZ[2]. 
%
%   BLITZ (Behavioral Learning In The Zebrafish) is a software that 
%   allows researchers to train larval zebrafish to associate 
%   visual pattern with electric shock in a fully automated way, which 
%   is adapted from MindControl.[3]
%   [1]: https://github.com/Wenlab/ABLITZER
%   [2]: https://github.com/Wenlab/BLITZ
%   [3]: https://github.com/samuellab/mindcontrol
%
%
%   Filename: yaml2matlab.m (method of ABLITZER class)
%   Abstract: 
%      Read in all recorded experimental data in one yaml file to an object
%      of ABLIZTER class.
%
%   SYNTAX:
%       1. yaml2matlab(obj,endFrame,pathName,fileName)
%       2. yaml2matlab(obj,endFrame), uigetfile will be activated to
%           manually select the file in GUI.
%       3. yaml2matlab(obj), read the file until the end
%   INPUT:
%       obj: the object of ABLITZER
%       endFrame: the last frame to read, if -1 entered, read to the end.
%       pathName: the pathname of the file to read
%       fileName: the filename of the file to read
%   OUTPUT: 
%       Implicit output, saved in the object of ABLITZER class.
% 
% 
% 
% 
% 
% 
%   
%   Current Version: 1.1
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Modified on: May 5, 2018
% 
%   Replaced Version: 1.0
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Created on: May 3, 2018
% 

% TODO: make readExpSettings, readFrames compatible with
% old format by adding oldFlag in argument list.
function yaml2matlab(obj,oldFlag,pathName,fileName)
 
if (nargin == 2)
    [fileName,pathName] = uigetfile('*yaml');
elseif (nargin == 1)
    oldFlag = false;
    [fileName,pathName] = uigetfile('*yaml');   
end

fName = [pathName, fileName];
fid = fopen(fName);
% read general experiment settings and fish personal infos
if oldFlag
    F = readExpSettings_old(fid,fileName);
    numFish = length(F);
    frames = readFrames_old(fid, numFish);
else
    F = readExpSettings(fid);
    numFish = length(F);
    frames = readFrames(fid, numFish);
end

% Assign values to the object of ABLITZER
for i = 1:numFish
    F(i).Frames = frames(:,i);
    obj.FishStack = cat(1,obj.FishStack,F(i));
end

end

% read general experiment settings and fish personal infos
function F = readExpSettings(fid)

ifReached = false; % logical value
while (~ifReached && ~feof(fid))
    disp('Reading the general experimental info');
    [key, value] = read_a_line(fid);
    if (~isempty(key))
        switch key
            case 'FishIDs'
                fishIDs = textscan(value,'%q','Delimiter',',');
                fishIDs = fishIDs{1,1};         
            case 'FishAge'
                fishAge = str2num(value);
            case 'Task'
                task = string(value);
            case 'CSpattern'
                csPattern = value;
            case 'FishStrain'
                fishStrain = value;
            case 'Arena'
                arena = str2num(value);
            case 'ExpStartTime'
                expStartTime = value;
            case 'FrameRate'
                frameRate = str2num(value);
            case 'FrameSize'
                frameSize = str2num(value);
            case 'xCut'
                xCut = str2num(value);
            case 'yCut'
                yCut = str2num(value);
            case 'yDivide'
                yDivide = str2num(value);
            case 'Frames'
                ifReached = true;
            otherwise
                disp(['Unrecognized keyword: ', key]);
        end
    end
end

numFish = length(fishIDs);
F(numFish) = FISHDATA;
for i=1:numFish
    F(i).ID = string(fishIDs{i,1});
    F(i).Age = fishAge;
    F(i).Strain = string(fishStrain);
    F(i).Arena = arena;
    F(i).ExpTask = task;
    F(i).CSpattern = string(csPattern);
    
    
    F(i).ExpStartTime = expStartTime;
    F(i).FrameRate = frameRate;
    
    %         Scheme for fish positions in arena
    %               xCut
    %         |		|		|
    %         |	0	|	1	|
    %         |		|		|
    %         |-------------| yCut
    %         |		|		|
    %         |	2	|	3	|
    %         |		|		|
    if (i==1)
        F(i).ConfinedRect = [0,0,xCut,yCut];
    elseif (i==2)
        F(i).ConfinedRect = [xCut,0,frameSize(1) - xCut,yCut];
    elseif (i==3)
        F(i).ConfinedRect = [0,yCut,xCut,frameSize(2) -yCut];
    elseif (i==4)
        F(i).ConfinedRect = [xCut,yCut,frameSize(1) - xCut,frameSize(2) -yCut];
    end
    F(i).yDivide = yDivide(i);
    if contains(task,'control','IgnoreCase',true)
        F(i).ExpType = "Control Group";
    elseif contains(task,'exp','IgnoreCase',true)
        F(i).ExpType = "Exp Group";
    else
        F(i).ExpType = "Unrecognized";
    end
end

end

% Extract fish's IDs, ages, strains and task from fileName
% Different infos are separated by "_"
function F = readExpSettings_old(fid,fileName)
    % extract infos from filename
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
    
    fishAge1 = str2num(fileName(idx(2)+1));
    fishAge2 = str2num(fileName(idx(4)+1));
    
    fishIDs = {fishID1;fishID2};
    fishAges = [fishAge1, fishAge2];
    fishStrains = [string(fishStrain1), string(fishStrain2)];
    task = fileName(idx(5)+1:end-5);
    
    ifReached = false; % logical value
    while (~ifReached && ~feof(fid))
        disp('Reading the general experimental info');
        [key, value] = read_a_line(fid);
        if (~isempty(key))
            switch key
                case 'ExpStartTime'
                    expStartTime = value;
                case 'FrameRate'
                    frameRate = str2num(value);
                case 'FrameSize'
                    frameSize = str2num(value);
                case 'DelimX'
                    delimX = str2num(value);
                case 'DelimY'
                    yDivide = str2num(value);
                case 'Frames'
                    ifReached = true;
                otherwise
                    disp(['Unrecognized keyword: ', key]);
            end
        end
    end
    
    numFish = length(fishIDs);
    F(numFish) = FISHDATA;
    for i=1:numFish
        F(i).ID = string(fishIDs{i,1});
        F(i).Age = fishAges(i);
        F(i).Strain = fishStrains(i);
        
        switch str2double(fishIDs{i,1}(3))
            case 1 || 4
                arena = 1;
            case 2 || 5
                arena = 2;
            case 3 || 6
                arena = 3;
        end
        F(i).Arena = arena;
        F(i).ExpTask = task;
        if contains(task,'control','IgnoreCase',true)
            F(i).ExpType = "Control Group";
        elseif contains(task,'exp','IgnoreCase',true)
            F(i).ExpType = "Exp Group";
        else
            F(i).ExpType = "Unrecognized";
        end

        F(i).ExpStartTime = expStartTime;
        F(i).FrameRate = frameRate;

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
        F(i).yDivide = yDivide;
        
    end
    

end

% read frames data from yaml
function frames = readFrames(fid, numFish)
% read frames until the end
MAXFRAMES = 100000;
frames(MAXFRAMES,numFish) = FRAMEDATA;
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
            case 'FishIdx'
                idxFish = str2num(value) + 1;
            case 'Head'
                frames(idxFrame,idxFish).Head = str2num(value);
            case 'Tail'
                frames(idxFrame,idxFish).Tail = str2num(value);
            case 'Center'
                frames(idxFrame,idxFish).Center = str2num(value);
            case 'HeadingAngle'
                frames(idxFrame,idxFish).HeadingAngle = str2num(value);
            case 'ShockOn'
                frames(idxFrame,idxFish).ShockOn = str2num(value);
            case 'PatternIdx'
                frames(idxFrame,idxFish).PatternIdx = str2num(value);
            otherwise
                disp(['Unrecognized keyword: ', key]);
        end
    end
end

frames(idxFrame:end,:) = []; % remove redundant frames


end

% read frames data from old format yamls
function frames = readFrames_old(fid, numFish)
% read frames until the end
MAXFRAMES = 100000;
frames(MAXFRAMES,numFish) = FRAMEDATA;
idxFrame = 1;

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
