% script to import data from yaml and do basic analysis to check there is
% light preference in this paradigm
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

%% Calculate the positional index
numFish = length(aObj.FishStack);
for i = 1:numFish
    fish = aObj.FishStack(i);
    fish.calcPItime;
end



%% Visualize the results

PItimeMat = zeros(numFish,2);
for i = 1:numFish
    fish = aObj.FishStack(i);
    PItimeMat(i,1) = fish.Res.PItime(1).PIfish;
    PItimeMat(i,2) = fish.Res.PItime(2).PIfish;
    
end
figure;
hold on;
xArr = 1:numFish;
scatter(xArr,PItimeMat(:,1),'markerEdgeColor','none','markerFaceColor','blue');
scatter(xArr,PItimeMat(:,2),'markerEdgeColor','none','markerFaceColor','red');

% plot the average levels for both phases
meanBaseline = mean(PItimeMat(:,1));
meanTest = mean(PItimeMat(:,2));

line([0,numFish+1],[meanBaseline,meanBaseline],'lineStyle',':','color','blue');
text(numFish+1,meanBaseline,sprintf('Average: %4.2f',meanBaseline)); 
line([0,numFish+1],[meanTest,meanTest],'lineStyle',':','color','red');
text(numFish+1,meanTest,sprintf('Average: %4.2f',meanTest)); 
% plot the arrow graph
quiver(xArr',PItimeMat(:,1),0*xArr',PItimeMat(:,2)-PItimeMat(:,1),0,...
    'color',[0,0,0],'MaxHeadSize',0.5,'lineWidth',1);
ylim([0,1]);

legend({'Baseline','Test'});
ylabel('Blue Preference Index');
xlabel('Fish Number');

title('12dpf-MW3-blueTest-with-the-fullWhite-pattern');