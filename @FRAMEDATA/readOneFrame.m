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
%   Filename: yaml2expData.m (method of FRAMEDATA class)
%   Abstract: 
%      Read in recorded experimental data of one camera frame in yaml file 
%      to an object of EXPDATA class.
%      
%
%   SYNTAX:
%       
%   INPUT:
%  
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
%

function readOneFrame(obj,fid)

    while (~feof(fid) && ~obj.isEndFrame)
        [key, value] = read_a_line(fid);
        if (~isempty(key))
            switch key
                case 'Frames'
                    obj.isEndFrame = 1;
                case 'FrameNum'
                    obj.FrameNum = str2num(value);
                case 'ExpPhase'
                    obj.ExpPhase = str2num(value);
                case 'sElapsed'
                    sElapsed = str2num(value);
                case 'msRemElapsed'
                    msRemElapsed = str2num(value);
                    obj.TimeElapsed = sElapsed +  msRemElapsed / 1000;
                case 'FishIdx'
                    obj.idxFish = str2num(value) + 1;
                case 'Head'
                    obj.FishData(obj.idxFish).Head = str2num(value);
                case 'Tail'
                    obj.FishData(obj.idxFish).Tail = str2num(value);
                case 'Center'
                    obj.FishData(obj.idxFish).Center = str2num(value);
                case 'HeadingAngle'
                    obj.FishData(obj.idxFish).HeadingAngle = str2num(value);
                case 'ShockOn'
                    obj.FishData(obj.idxFish).ShockOn = str2num(value);
                case 'PatternIdx'
                    obj.FishData(obj.idxFish).PatternIdx = str2num(value); 
                otherwise
                    disp(['Unrecognized keyword: ', key]);
            end
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


