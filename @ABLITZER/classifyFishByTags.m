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
%   Filename: classifyFishByTags.m (method of ABLITZER class)
%   Abstract: 
%      Classify fishStack into groups of full combinations of tags,
%   and record indices in fishGroup struct
%
%   SYNTAX:
%       1. classifyFishByTags(obj,tags)
%       2. obj.classifyFishByTags(tags)
%   INPUT:
%       obj: the object of ABLITZER
%       tags: string array, represents which field user to classify
%   into different groups based on different values of this field.
%   the number of tags should no more than 3, otherwise, it may cause
%   memory failure
%
%   OUTPUT: 
%       Implicit output, saved the classified results in fishGroup struct
%   in called ABLITZER object 
% 
% 
% 
% 
% 
% 
%   
%   Current Version: 1.3
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Modified on: May 14, 2018
% 
%   Replaced Version: 1.1
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Created on: May 3, 2018
% 

function classifyFishByTags(obj,tags)
	fishStack = obj.FishStack;
    %numFish = length(fishStack);
    numTags = length(tags);
    names = [];
    for i=1:numTags
        temp = cat(1,fishStack.get(char(tags(i))));
        names = cat(2,names,temp);
    end
    
    names = string(names);
    uniqCombo = unique(names,'rows');
    numUniq = size(uniqCombo,1);
    idxCell = cell(numUniq,1);
    for i=1:size(names,1)
        for j=1:numUniq
            if strcmp(names(i,1),uniqCombo(j,1)) && strcmp(names(i,2),uniqCombo(j,2))
                idxCell{j,1} = cat(2,idxCell{j,1},i);
                break;
            end
        end 
    end

    for i = 1:numUniq
        groupName = "";
        for j = 1:numTags
            groupName = groupName + uniqCombo(i,j);
            if j ~= numTags % add separator between tags
                groupName = groupName + "_";
            end
        end
        
        obj.FishGroups(i).Name = groupName;
        obj.FishGroups(i).Tag = tags;
        obj.FishGroups(i).Data = idxCell{i,1};
    end

end