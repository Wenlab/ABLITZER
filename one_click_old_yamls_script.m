% Daily Exp Data Processing Script
% Import all data from yamls and save ABLITZER data object
% Plot the uni-variable scatter
aObj = ABLITZER;
pathName = 'F:\FishExpData\operantLearning\';
aObj.processOneDayYamls(pathName);
fishStack = aObj.FishStack;
tags = ["Strain","ExpType"];
aObj.classifyFishByTags(tags);

% Statistically Plot GCaMP Data
aObj.plotPIsOfGroup(2,1);
% Statistically Plot WT Data
aObj.plotPIsOfGroup(4,3);
