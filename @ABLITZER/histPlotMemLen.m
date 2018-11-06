% plot the histograms of memory lengths in different cases
function histPlotMemLen(obj, ...% ABLITZER object
    patterns,... % string array of patterns; []: all patterns
    binEdges) % edges of bins
    
    obj.classifyFish("CSpattern");
    if isempty(patterns)
        patterns = cat(2,obj.FishGroups.Value);
        idxP = 1:length(patterns);
    else
        idxP = [];
        P = cat(2,obj.FishGroups.Value);
        for i = 1:length(patterns)
            idx = find(contains(P,patterns(i)));
            idxP = cat(2,idxP,idx); % indices of user-input patterns in the classification results
        end
    end
    
    numPatterns = length(idxP);
    memLens = cell(numPatterns,1);
    for i = 1:numPatterns
        idx = idxP(i);
        idxPattern = obj.FishGroups(idx).Data;
        tempMemLens = [];
        for j = 1:length(idxPattern)
            idx = idxPattern(j);
            fish = obj.FishStack(idx);
            if contains(fish.ExpType,'exp','IgnoreCase',true)
                tempMemLens = cat(2,tempMemLens,fish.Res.ExtinctTime);
            end
        end
        memLens{i,1} = tempMemLens;  
    end
    
    % calculate the statistics
    numBins = length(edges)-1;
    M = zeros(numBins,numPatterns);
    SEMs = zeros(numBins,numPatterns);
    
    xtLabels = cell(1,numBins);
    for i = 1:numPatterns
        tempMemLens = tempMemLens{i,1};
        for j = 1:numBins
            lowerBound = binEdges(j);
            upperBound = binEdges(j+1);

            idx = find((tempMemLens >= lowerBound)&&(tempMemLens < upperBound));
            M(j,i) = mean(tempMemLens(idx));
            SEMs(j,i) = std(tempMemLens(idx),1,1)/sqrt(length(idx));
            xtLabels{1,j} = sprintf('%d ~ %d',lowerBound, upperBound);
        end
    end
    
    
    
    
    
    % use barPlot to plot
    yLab = "Memory Length (s)";
    
    barPlot(M,"errorbar",SEMs,"xticklabels",xtLabels,"ylabel",yLab);
    
    
end