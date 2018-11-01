%% Script for processing intensity-ratio modulated FISHDATA

%% Import YAMLs
aObj = ABLITZER;
date = inputdlg;
date = string(date{1,1});
aObj.loadYamls([],'F:\FishExpData\',date);

%% Remove invalid data
aObj.removeInvalidData("paired",0.95);

%% Evaluate performance
for i = 1:length(aObj.FishStack)
    fish = aObj.FishStack(i);
    fish.ratePerformance;
end


%% Visualize results
