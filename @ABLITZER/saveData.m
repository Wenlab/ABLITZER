%Abstract:
% save FishData into different files based on keys
%
%SYNTAX:
%       1. obj.removeInvalidData(ifPaired), remove invalid data in pair or
%       individually; (In a day, ID is unique for each fish from the same
%       strain.)
%       2. obj.removeInvalidData(ifPaired,qualThre),
%  
%
% Test git add and commit single file
% save FishData into different files based on keys
function saveData(obj,... % ABLITZER object
    keys,... % keys to classify fishData into groups
    savingPath, ... % path to save files
    maxFishNum) % max number of fish in a single file, make sure MATLAB can handle those files
% because MATLAB cannot get the memory of an object directly

if nargin == 1
    maxFishNum = 16;
    savingPath = uigetdir;
    keys = ["ExpStartTime","Arena","Strain","Age","ExpTask","CSpattern"];
    obj.classifyFish(keys);
    for i = 1:length(obj.FishGroups)
        fishGroup = obj.FishGroups(i);
        fileName = fishGroup.Value;
        if length(fishGroup.Data) < maxFishNum
            save([savingPath,fileName,'.mat'],obj);
        else
            numFish = length(obj.FishStack);
            for j = 1:floor(numFish/maxFishNum)
                tempObj = ABLITZER;
                idx = (1:maxFishNum)+(j-1)*maxFishNum;
                tempObj.FishStack = obj.FishStack(idx);
                postfix = sprintf('_%d.mat',j);
                save([savingPath,fileName,postfix],obj);
            end
            postfix = sprintf('_%d.mat',j+1);
            save([savingPath,fileName,postfix],obj);
        end
    end
    
elseif nargin == 2
    maxFishNum = 16;
    savingPath = uigetdir;
    %keys = ["ExpStartTime","Arena","Strain","Age","ExpTask","CSpattern"];
    obj.classifyFish(keys);
    for i = 1:length(obj.FishGroups)
        fishGroup = obj.FishGroups(i);
        fileName = fishGroup.Value;
        if length(fishGroup.Data) < maxFishNum
            save([savingPath,fileName,'.mat'],obj);
        else
            numFish = length(obj.FishStack);
            for j = 1:floor(numFish/maxFishNum)
                tempObj = ABLITZER;
                idx = (1:maxFishNum)+(j-1)*maxFishNum;
                tempObj.FishStack = obj.FishStack(idx);
                postfix = sprintf('_%d.mat',j);
                save([savingPath,fileName,postfix],obj);
            end
            postfix = sprintf('_%d.mat',j+1);
            save([savingPath,fileName,postfix],obj);
        end
    end
    
    
elseif nargin == 3
    maxFishNum = 16;
    %savingPath = uigetdir;
    %keys = ["ExpStartTime","Arena","Strain","Age","ExpTask","CSpattern"];
    obj.classifyFish(keys);
    for i = 1:length(obj.FishGroups)
        fishGroup = obj.FishGroups(i);
        fileName = fishGroup.Value;
        if length(fishGroup.Data) < maxFishNum
            save([savingPath,fileName,'.mat'],obj);
        else
            numFish = length(obj.FishStack);
            for j = 1:floor(numFish/maxFishNum)
                tempObj = ABLITZER;
                idx = (1:maxFishNum)+(j-1)*maxFishNum;
                tempObj.FishStack = obj.FishStack(idx);
                postfix = sprintf('_%d.mat',j);
                save([savingPath,fileName,postfix],obj);
            end
            postfix = sprintf('_%d.mat',j+1);
            save([savingPath,fileName,postfix],obj);
        end
    end
elseif nargin == 4
    obj.classifyFish(keys);
    for i = 1:length(obj.FishGroups)
        fishGroup = obj.FishGroups(i);
        fileName = fishGroup.Value;
        if length(fishGroup.Data) < maxFishNum
            save([savingPath,fileName,'.mat'],obj);
        else
            numFish = length(obj.FishStack);
            for j = 1:floor(numFish/maxFishNum)
                tempObj = ABLITZER;
                idx = (1:maxFishNum)+(j-1)*maxFishNum;
                tempObj.FishStack = obj.FishStack(idx);
                postfix = sprintf('_%d.mat',j);
                save([savingPath,fileName,postfix],obj);
            end
            postfix = sprintf('_%d.mat',j+1);
            save([savingPath,fileName,postfix],obj);
        end
    end
end




end