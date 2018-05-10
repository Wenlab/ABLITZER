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

% TODO: make the snippet into code blocks
function yaml2matlab(obj,endFrame,pathName,fileName)

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

fName = [pathName, fileName];
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
                task = value;
            case 'FishStrains'
                fishStrains = str2num(value);
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

% Assign values to the object of ABLITZER
for i = 1:numFish
    F(i).Frames = frames(:,i);
    F(i).ID = fishIDs(i);
    F(i).Age = fishAges(i);
    F(i).Strain = fishStrains(i);
    F(i).ExpTask = task;
    
    
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
        F(i).ExpType = 'Control Group';
    elseif contains(task,'exp','IgnoreCase',true)
        F(i).ExpType = 'Exp Group';
    else
        F(i).ExpType = 'Unrecognized';
    end
    obj.FishStack = cat(1,obj.FishStack,F(i));
end

end








% Read the general experimental info
% before frames data by the keyword-"Frames"
function read_until_frames(obj,fid)
    
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
                    task = value;
                case 'FishStrains'
                    fishStrains = str2num(value);    
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
   
    for i = 1:length(fishIDs)
        F = FISHDATA;
        F.ID = fishIDs(i);
        F.Age = fishAges(i);
        F.Strain = fishStrains(i);
        F.ExpTask = task;
        
        
        F.ExpStartTime = expStartTime;
        F.FrameRate = frameRate;
        
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
            F.ConfinedRect = [0,0,xCut,yCut]; 
        elseif (i==2)
            F.ConfinedRect = [xCut,0,frameSize(1) - xCut,yCut];
        elseif (i==3)
            F.ConfinedRect = [0,yCut,xCut,frameSize(2) -yCut];
        elseif (i==4)
            F.ConfinedRect = [xCut,yCut,frameSize(1) - xCut,frameSize(2) -yCut];
        end
        F.yDivide = yDivide(i);
        
        % Append the object of FISHDATA to corresponding group.
        if contains(task,'control','IgnoreCase',true)
            F.ExpType = 'Control Group';
            obj.ControlGroup = [obj.ControlGroup, F];
        elseif contains(task,'exp','IgnoreCase',true)
            F.ExpType = 'Exp Group';
            obj.ExpGroup = [obj.ExpGroup, F];
        else
            F.ExpType = 'Unrecognized';
            error('Unrecognized group of this FISHDATA!');
        end
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