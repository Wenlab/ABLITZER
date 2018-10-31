%% Script for processing intensity-ratio modulated FISHDATA

%% Import YAMLs
aObj = ABLITZER;
date = inputdlg;
date = string(date{1,1});
aObj.loadYamls([],'F:\FishExpData\',date);

%% Remove invalid data
numFish = length(aObj.FishStack);
idxRemove = [];
for i = 1:numFish
    fish = aObj.FishStack(i);
    fish.evaluateDataQuality;
    if (fish.Res.DataQuality < 0.9)
        idxRemove = [idxRemove,i];
    end
end

aObj.FishStack(idxRemove) = [];

%% Visualize results
