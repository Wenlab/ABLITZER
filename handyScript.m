%% Plot learning-curve for each fish in the experiment group
for i = 1:16
fish = obj.FishStack(idx(i));
fish.plotLearningCurve('positional');
pause;
end

%% Plot distance to centerline for each fish in the experiment group
h = figure;
figNum = h.Number;
for i = 1:length(idx)
fish = aObj.FishStack(idx(i));
fish.plotDist2centerline;
pause;
end

