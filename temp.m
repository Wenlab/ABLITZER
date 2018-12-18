% Plot heat map

% first, plot a heat map for a single fish
numBins = 10;
pixelSize = 0.09; % mm/pixel
fish = aObj.FishStack(1);
fish.evaluateDataQuality;
heads = cat(1,fish.Frames.Head);
[N,Xedges,Yedges] = histcounts2(heads(:,1),heads(:,2),numBins);
N = N / sum(N(:)); % normalization

width = fish.ConfinedRect(3);
height = fish.ConfinedRect(4);
xlabels = ((1:width/numBins:width) + width/2/numBins)*pixelSize;
ylabels = ((1:height/numBins:height) + height/2/numBins)*pixelSize;

figure;
h = heatmap(xlabels,ylabels,N,'CellLabelColor','none');

title('Heat map of fish track density distribution');
xlabel('Horizontal (mm)');
ylabel('Vertical (mm)');