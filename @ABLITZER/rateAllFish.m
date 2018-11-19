% Rate performances for all fish
function   rateAllFish(obj)
    for i = 1:length(obj.FishStack)
        fish = obj.FishStack(i);
        fish.ratePerformance;
    end



end