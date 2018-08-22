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
%   Filename: classifyFishByKeys.m (method of ABLITZER class)
%   Abstract:
%      Classify fishStack into groups of full combinations of keys,
%   and record indices in fishGroup struct
%
%   SYNTAX:
%       1. classifyFishByKeys(obj,keys)
%       2. obj.classifyFishByKeys(keys)
%   INPUT:
%       obj: the object of ABLITZER
%       keys: string array, represents which field user to classify
%   into different groups based on different values of this field.
%   the number of keys should no more than 3, otherwise, it may cause
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
% �ñ�׼�ļ�ֵ��������������


function classifyFishByKeys(obj,keys)
	fishStack = obj.FishStack;
    obj.FishGroups = []; % clear former classification
    %numFish = length(fishStack);
    numKeys = length(keys);
    values = [];
    for i=1:numKeys
        temp = cat(1,fishStack.get(char(keys(i))));
        values = cat(2,values,temp);
    end

    values = string(values);
    uniqCombo = unique(values,'rows');
    numUniq = size(uniqCombo,1);
    idxCell = cell(numUniq,1);
    for i=1:size(values,1)
        for j=1:numUniq
            if values(i,:) == uniqCombo(j,:)
                idxCell{j,1} = cat(2,idxCell{j,1},i);
                break;
            end
        end
    end

    for i = 1:numUniq
        groupValue = "";
        for j = 1:numKeys
            groupValue = groupValue + uniqCombo(i,j);
            if j ~= numKeys % add separator between tags
                groupValue = groupValue + "_";
            end
        end

        obj.FishGroups(i).Value = groupValue;
        obj.FishGroups(i).Key = keys;
        obj.FishGroups(i).Data = idxCell{i,1};
    end

end
