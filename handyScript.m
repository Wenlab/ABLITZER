% Batchly process group of fish data to get performance index figures based
% on time and turn
tags = ["GCaMP","OL","redBlackCheckerboard"];
obj = batchly_load_files_by_tags(tags);
for i=1:length(obj.FishStack)
obj.FishStack(i).ratePerformance;
end
obj.classifyFishByTags("ExpType");
obj.plotPIsOfGroup(2,1,'time');
obj.plotPIsOfGroup(2,1,'turn');
obj.plotOntogenyByPI('time');
obj.plotOntogenyByPI('turn');






% get statitics of memory extinction of experiment and control fishData
CStimeThre = 7; % seconds
extMat = zeros(82,2);
for i=1:82
    extMat(i,1) = expData(i).measureMemory(CStimeThre);
    extMat(i,2) = ctrlData(i).measureMemory(CStimeThre);  
end




% check if there is any correlation between extinction and performance
% index in the training
PImat = zeros(82,2);
for i=1:82
    PImat(i,1) = expData(i).Res.PItime(2).PIfish - expData(i).Res.PItime(1).PIfish;
    PImat(i,2) = ctrlData(i).Res.PItime(2).PIfish - ctrlData(i).Res.PItime(1).PIfish; 
end

Rsq = calc_Rsquare(PImat(:,1),extMat(:,1));


% calculate distance to centerline as several histograms

% obj.classifyFishByTags("ExpType");
% expIdx = obj.FishGroups(2).Data;
% numFish = length(expIdx);
% numFrames = 29398;
% allY2CL = zeros(numFish,numFrames);
% for n = 1:numFish
%     % for single fish
%     idx = expIdx(n);
%     fish = obj.FishStack(idx);
%     height = fish.ConfinedRect(4);
%     yDiv = fish.yDivide;
%     pIdx = cat(1,fish.Frames.PatternIdx);
%     heads = cat(1,fish.Frames.Head);
%     %numFrames = length(pIdx);
%     y2CL = zeros(1,numFrames); % distance (in y) to center line
%     for i=1:numFrames
%         if pIdx(i) == 0
%             y2CL(i) = heads(i,2) - yDiv;
%         elseif pIdx(i) == 1
%             y2CL(i) = yDiv - heads(i,2);
%         end
% 
%     end
%     allY2CL(n,:) = y2CL;
% end
% 
% nBins = 5;
% width = floor(numFrames / 5);
% allY2CLbins = zeros(numFish,nBins);
% for n = 1:numFish
% for i = 1:nBins
%     idx = ((i-1)*width+1):i*width;
%     allY2CLbins(n,i) = mean(allY2CL(n,idx));
%     
% end
% end
% 
% 
% 
% 
% 
% 
% 
% % script to record some handy snippets or functions 
% aObj = ABLITZER;
% numFiles = length(dataCell);
% for i=1:numFiles
%     tempObj = dataCell{i,1};
%     for j = 1:length(tempObj.FishStack)
%         tempObj.FishStack(j).ratePerformance();
%     end
%     tempObj = filter_invalid_data(tempObj);
%     aObj.FishStack = cat(1,aObj.FishStack,tempObj.FishStack);
%     
% end

% measure the linear correlation between two variables
function  Rsq = calc_Rsquare(x, y)
p = polyfit(x,y,1);
yFit = polyval(p,x);
yResid = y - yFit;
SSresid = sum(yResid.^2);
SStotal = (length(y)-1) * var(y);
Rsq = 1 - SSresid / SStotal;

end



% Eliminate fish whose dataQuality is lower than qualThre (0.95)
% once expData/ctrlData eliminated, both data eliminated
function obj = filter_invalid_data(obj)
    qualThre = 0.95;
    badIndices = []; % store bad index pairs
    obj.classifyFishByTags("ID");
    idxPairs = cat(1,obj.FishGroups.Data);
    for i=1:size(idxPairs,1)
        idx1 = idxPairs(i,1);
        idx2 = idxPairs(i,2);
        if (obj.FishStack(idx1).Res.DataQuality < qualThre) || ...
              (obj.FishStack(idx2).Res.DataQuality < qualThre)  
            badIndices = cat(2,badIndices,idxPairs(i,:));
        end
      
    end
    
    obj.FishStack(badIndices) = [];
    
    
    
end


function PIs = get_all_PIs(obj)
    fishStack = obj.FishStack;
    numFish = length(fishStack);
    PIs = [];
    for i=1:numFish
        fish = fishStack(i);
        tempPI = cat(2,fish.Res.PItime.PIfish);
        PIs = cat(1,PIs,tempPI);
        
        
        
    end
end









