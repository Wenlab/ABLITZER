% the behavioral analysis to the fish population of the same strain
%sObj = ABLITZER; 
%sObj.loadMats; % load fishData from the same strain

%% Process the data, do the computation
numBins = 10;
pixelSize = 0.09; % mm/pixel
numFish = length(sObj.FishStack);
popStat = struct;
motRatios = zeros(numFish,1); % the percentage of motile states
meanACs = zeros(numFish,1); % the mean of heading angle changes
meanBoutIntervals = zeros(numFish,1); % the mean of bout intervals
meanBoutDurations = zeros(numFish,1);
meanBoutDistances = zeros(numFish,1);

varACs = zeros(numFish,1); % the mean of heading angle changes
varBoutIntervals = zeros(numFish,1); % the mean of bout intervals
varBoutDurations = zeros(numFish,1);
varBoutDistances = zeros(numFish,1);

ds = zeros(numBins,numBins,numFish);
for i = 1:numFish
    fish = sObj.FishStack(i);
    fish.evaluateDataQuality;
    fish.calcPIturn;
    heads = cat(1,fish.Frames.Head);
    [N,Xedges,Yedges] = histcounts2(heads(:,1),heads(:,2),numBins);
    N = N / sum(N(:));
    ds(:,:,i) = N;
    boutStat = fish.boutAnalysis;
    if isempty(boutStat)
        motRatios(i) = fish.Res.DataQuality;
        meanACs(i) = nan;
        varACs(i) = nan;
        meanBoutIntervals(i) = nan;
        varBoutIntervals(i) = nan;
        meanBoutDurations(i) = nan;
        varBoutDurations(i) = nan;
        meanBoutDistances(i) = nan;
        varBoutDistances(i) = nan;   
        continue;
    end
    boutIntervals = cat(1,boutStat.interval);
    boutDurations = cat(1,boutStat.duration);
    boutDistances = cat(1,boutStat.dist);
    
    % get the heading angle changes
    headingAnlges = cat(1,fish.Frames.HeadingAngle);
    angleChanges = diff(headingAnlges);
    
    motRatios(i) = fish.Res.DataQuality;
    meanACs(i) = mean(abs(angleChanges));
    varACs(i) = var(angleChanges);
    meanBoutIntervals(i) = mean(boutIntervals);
    varBoutIntervals(i) = var(boutIntervals);
    meanBoutDurations(i) = mean(boutDurations);
    varBoutDurations(i) = var(boutDurations);
    meanBoutDistances(i) = mean(boutDistances);
    varBoutDistances(i) = var(boutDistances);
end

popStat.Strain = fish.Strain;
popStat.motRatios = motRatios;
popStat.meanACs = meanACs;
popStat.varACs = varACs;
popStat.meanBoutIntervals = meanBoutIntervals;
popStat.varBoutIntervals = varBoutIntervals;
popStat.meanBoutDurations = meanBoutDurations;
popStat.varBoutDurations = varBoutIntervals;
popStat.meanBoutDistances = meanBoutDistances;
popStat.varBoutDurations = varBoutIntervals;

%% Visualize the results
% plot the averaged heatmap of all fish
meanN = mean(ds,3);
width = fish.ConfinedRect(3);
height = fish.ConfinedRect(4);
xlabels = ((1:width/numBins:width) + width/2/numBins)*pixelSize;
ylabels = ((1:height/numBins:height) + height/2/numBins)*pixelSize;

figure;
h = heatmap(xlabels,ylabels,meanN,'CellLabelColor','none');

title('Heat map of fish track density distribution');
xlabel('Horizontal (mm)');
ylabel('Vertical (mm)');


figure;
UnivarScatter(motRatios,'Label',{char(fish.Strain)});
ylabel('Motile Ratio');




