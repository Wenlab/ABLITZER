fishStack = obj.FishStack;
numFish = length(fishStack);
%% This one is only applied to redBlackCheckerboard case
for i=1:numFish
    fish = fishStack(i);
    fish.CSpattern = "redBlackCheckerboard";  
    num = char(fish.ID);
    num = num(3);
    if (num == 1 || 4)      
        fish.Arena = 1;
    elseif (num == 2 || 5)
        fish.Arena = 2;
    elseif (num == 3 || 6)
        fish.Arena = 3;
    end
    fish.ratePerformance();
end