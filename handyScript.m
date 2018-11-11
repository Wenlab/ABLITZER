%% Plot learning-curve for each fish in the experiment group
for i = 1:16
fish = obj.FishStack(idx(i));
fish.plotLearningCurve('positional');
pause;
end

%% Plot distance to centerline for each fish in the experiment group
h = figure;
figNum = h.Number;
for i = 1:length(idxExp)
    
    idx = idxExp(i);
    fish = aObj.FishStack(idx);
    subplot(2,1,1);
    cla;
    fish.plotDist2centerline(0,"withShadow",1,"shocks",1);
    subplot(2,1,2);
    cla;
fish.plotLearningCurve('positional');
[h, p, extincTime] = fish.sayIfLearned;
fprintf("%s-%s-%ddpf-%s-%s\n",fish.ExpDate,fish.ExpTime,fish.Age,fish.ID,fish.CSpattern);
if h == 1
fprintf('Smart fish\n');
else
fprintf('Stupid fish\n');
end
fprintf('P-value: %4.2f\n',p);
pause;
end

%% Convert old expStartTime to the current format
for i = 1:length(aObj.FishStack)
    fish = aObj.FishStack(i);
    expStartTime = fish.ExpStartTime;
if (length(expStartTime) > 16)
    if strcmp(expStartTime(5:7),'Apr')
        month = '04';
    elseif strcmp(expStartTime(5:7),'May')
        month = '05';
    elseif strcmp(expStartTime(5:7),'Jun')
        month = '06';
    elseif strcmp(expStartTime(5:7),'Jul')
        month = '07';
    elseif strcmp(expStartTime(5:7),'Aug')
        month = '08';
    elseif strcmp(expStartTime(5:7),'Sep')    
        month = '09';
    end
    day = expStartTime(9:10);
    if isspace(day(1))
        day(1) = '0';
    end
    
    date = ['2018',month,day];
    hour = expStartTime(12:13);
    minute = expStartTime(15:16);
    time = [hour,minute];
    fish.ExpStartTime = [date,'_',time];
    fish.ExpDate = date;
    fish.ExpTime = time;
else
    fish.ExpDate = expStartTime(1:8);
    fish.ExpTime = expStartTime(10:13);
end

end

%% Shock analysis
aObj.classifyFish("ExpType");
idxExp = aObj.FishGroups(2).Data;
idxCtrl = aObj.FishGroups(1).Data;
shockMatExp = zeros(length(idxExp),2);
shockMatCtrl = zeros(length(idxCtrl),2);

for i = 1:length(idxExp)
    idx = idxExp(i);
    fish = aObj.FishStack(idx);
    shockTimings = fish.Res.PIshock.ShockTiming;
    shockMatExp(i,1) = length(find(shockTimings < 6000));
    shockMatExp(i,2) = length(find(shockTimings >= 6000));
    
    
end






