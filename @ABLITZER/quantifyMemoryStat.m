function quantifyMemoryStat(obj)
    numFish = length(obj.FishStack);
    lenTest = 10740;
    sSum = zeros(1,lenTest);
    for i=1:numFish
        fish = obj.FishStack(i);
        scores = fish.Res.PItime(4).Scores;
        s = scores > 0; % convert it to proportion score
        sSum = cat(1,sSum,s(1:lenTest)');
        
        
        
    end
    x = 1:lenTest;
    y = mean(sSum,1);
    errBar = std(sSum,1,1)/size(sSum,1);
    
    shadedErrorBar(x,y,errBar);
    ylim([0,1]);
    
    

end