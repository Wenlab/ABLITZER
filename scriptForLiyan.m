% One-click script for Liyan
% Written by Wenbin Yang (bysin7@gmail.com)

%% Load yamls/Mats
aObj = ABLITZER;
aObj.loadYamls;

%% Process the data, do the necessary computation
% get the percentage of motile in the res.DataQuality
fish.evaluateDataQuality;

% find all turns and do the statistics
fish.calcPIturn; % TODO: rewrite the PIturn

% perform the bout-analysis



%% Visualize the results


