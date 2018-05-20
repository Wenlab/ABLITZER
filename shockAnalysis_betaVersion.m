obj.classifyFishByTags("ExpType");
fishStack = obj.FishStack;
expFish = fishStack(obj.FishGroups(2).Data);
numFish = length(expFish);

shockCell = cell(numFish,1);
for i=1:numFish
fish = expFish(i);
if (fish.Res.DataQuality < 0.95)
    continue;
end
shockCell{i,1} = fish.Res.PIshock;

end

figure;
hold on;
for i=1:length(shockCell)
    if (isempty(shockCell{i,1}))
        continue;
    end
    shockTiming = shockCell{i,1}.ShockTiming;
    scatter(shockTiming,i*ones(size(shockTiming)),'.');
end

nBins = 3; % number of bins to count
nShocksArr = [];
shocksOn = [];
for i=1:length(shockCell)
    if (isempty(shockCell{i,1}))
        continue;
    end
    shockTiming = shockCell{i,1}.ShockTiming;
    N = histcounts(shockTiming,nBins);
    nShocksArr = cat(1,nShocksArr,N);
    shocksOn = cat(1,shocksOn,shockTiming);
end
%histogram(shocksOn,nBins);

figure;
set(gca,'YGrid','on'); % add yGrid to help compare data
labels = {'Beginning','Mid-term','Final'};
colors = 0.8*ones(6,3);
UnivarScatter(nShocksArr,'Label',labels,'MarkerFaceColor',colors,...
'SEMColor',colors/1.5,'StdColor',colors/2);
UnivarScatter(nShocksArr,'MarkerFaceColor',colors,...
'SEMColor',colors/1.5,'StdColor',colors/2);






