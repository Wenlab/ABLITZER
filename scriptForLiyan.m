% One-click script for Liyan
% Written by Wenbin Yang (bysin7@gmail.com)

%% Load yamls/Mats
aObj = ABLITZER;
aObj.loadYamls;

%% Process the data, do the necessary computation
% classify fishData on strains
aObj.classifyFish("Strain");
for i = 1:length(aObj.FishGroups)
    strainName = aObj.FishGroups(i).Value;
    indices = aObj.FishGroups(i).Data;
    motPercent = [];
    meanACs = []; % also include variance?
    varACs = [];
    meanBoutIntervals = [];
    meanBoutDurations = [];
    meanBoutDistances = [];
    for idxFish = 1:length(indices)
        fish = aObj.FishStack(idxFish);
        
        % get the percentage of motile in the res.DataQuality
        fish.evaluateDataQuality;
        
        % find all turns and do the statistics
        fish.calcPIturn; % TODO: rewrite the PIturn
        
        % perform the bout-analysis
        boutStat = fish.boutAnalysis;
        motPercent = cat(1,motPercent,fish.Res.DataQuality);
        headingAnlges = cat(fish.Frames.HeadingAngle);
        angleChanges = diff(headingAnlges);
        meanACs = cat(1,meanACs,mean(abs(angleChanges)));
        varACs = cat(1,varACs,var(abs(angleChanges)));
        meanBoutIntervals = cat(1,meanBoutIntervals,mean(cat(1,boutStat.interval)));
        meanBoutDurations = cat(1,meanBoutDurations,mean(cat(1,boutStat.duration)));
        meanBoutDistances = cat(1,meanBoutDistances,mean(cat(1,boutStat.dist)));
        
    end
    
    
    %% Visualize the results
    % plot fish track (heatmap)
    plot_fish_track(fish);
    % pie-plot the percentage of motile states
    plot_motile_percentage(mean(motPercent));
    % plot angle change distribution of (all turns)
    figure;
    scatter(1:length(meanACs),meanACs);
    xlabel('No. Fish');
    ylabel('Heading-angle Change (deg)');
    
    % plot the distribution of bout-to-bout intervals
    figure;
    scatter(1:length(meanBoutIntervals),meanBoutIntervals);
    xlabel('No. Fish');
    ylabel('Mean Bout Intervals (s)');
    
    % plot the distribution of bout durations
    figure;
    scatter(1:length(meanBoutDurations),meanBoutDurations);
    xlabel('No. Fish');
    ylabel('Mean Bout Durations (s)');
    
    % plot the distribution of bout distance
    figure;
    scatter(1:length(meanBoutDistances),meanBoutDistances);
    xlabel('No. Fish');
    ylabel('Mean Bout Distance (mm)');
    
    
    
    
    
end

function plot_fish_track(fish) % for a single fish
    pixelSize = 40 ./ fish.ConfinedRect(4);
    heads = cat(1,fish.Frames.Head);
    x = heads(:,1)*pixelSize;
    y = heads(:,2)*pixelSize;
    figure;
    plot_color(x,y,1:length(x));
    colorbar;
    title('Fish Track');
    xlabel('Horizontal (mm)');
    ylabel('Vertical (mm)');
    
end

function plot_motile_percentage(p)
    figure;
    q = 1 - p;
    pie([p,q],{'Motile','Non-Motile'});

end

function hist_bout_intervals(boutIntervals)
figure;
histogram(boutIntervals,'Normalization','probability');
xlabel('Bout Interval (s)');

end

function hist_bout_durations(boutDurations)
figure;
histogram(boutDurations,'Normalization','probability');
xlabel('Bout Duration (s)');
end

function hist_bout_distances(boutDistances)
figure;
histogram(boutDistances,'Normalization','probability');
xlabel('Bout Distance (s)');
end


