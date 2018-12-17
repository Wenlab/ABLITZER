% Single fish analysis
%aObj = ABLITZER;
%aObj.loadMats;
fish = aObj.FishStack(1); % change the index to choose other fish

%% process the data, do the computation
% get the percentage of motile in the res.DataQuality
fish.evaluateDataQuality;

% find all turns and do the statistics
fish.calcPIturn;

% perform the bout-analysis
boutStat = fish.boutAnalysis;
boutIntervals = cat(1,boutStat.interval);
boutDurations = cat(1,boutStat.duration);
boutDistances = cat(1,boutStat.dist);

% get the heading angle changes
headingAnlges = cat(1,fish.Frames.HeadingAngle);
angleChanges = diff(headingAnlges);

%% Visualize the results
figure;
% plot the track of fish
subplot(3,2,1);
plot_fish_track(fish); 

% pie-plot the percentage of motile states (TODO: add the number)
subplot(3,2,2);
p = fish.Res.DataQuality;
q = 1 - p;
pie([p,q],{'Motile','Non-Motile'});

% plot the distribution of angle changes
subplot(3,2,3);
histogram(angleChanges,'Normalization','probability');
xlabel('Heading-angle Change (deg)');
ylabel('Probability');

% plot the distribution of bout-to-bout intervals (TODO: add the binedges)
subplot(3,2,4);
histogram(boutIntervals,'Normalization','probability');
xlabel('Bout Interval (s)');
ylabel('Probability');

% plot the distribution of bout durations
subplot(3,2,5);
histogram(boutDurations,'Normalization','probability');
xlabel('Bout Duration (s)');
ylabel('Probability');

% plot the distribution of bout distance
subplot(3,2,6);
histogram(boutDistances,'Normalization','probability');
xlabel('Bout Distance (mm)');
ylabel('Probability');



function plot_fish_track(fish) % for a single fish
    pixelSize = 40 ./ fish.ConfinedRect(4);
    heads = cat(1,fish.Frames.Head);
    idxR = find((heads(:,1) < 0) | (heads(:,2) < 0));
    heads(idxR,:) = [];
    x = heads(:,1)*pixelSize;
    x = x - min(x) + 2;
    y = heads(:,2)*pixelSize;
    y = y - min(y) + 2;
    plot_color(x,y,1:length(x));
    colorbar;
    xlim([min(x)-2,max(x)+2]);
    ylim([min(y)-2,max(y)+2]);
    title('Fish Track');
    xlabel('Horizontal (mm)');
    ylabel('Vertical (mm)');
    
end

