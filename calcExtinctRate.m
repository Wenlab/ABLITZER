SmartfishStack = MemoryLengthStack(4).SmartfishStack;
    for k = 1:length(SmartfishStack)
        if SmartfishStack(k).MemoryLength ~= 1080
            age = SmartfishStack(k).fishAge;
            IDstr = SmartfishStack(k).fishID;
            MemLen = SmartfishStack(k).MemoryLength;
            trialNum = MemLen/120;
            fishIdx = findFish(aObj,"ExpTask","OLexp","Age",age,"ID",IDstr);
            PIdelta = aObj.FishStack(fishIdx).Res.PItime(4).Trial(trialNum+1) ...
                - aObj.FishStack(fishIdx).Res.PItime(4).Trial(1);
            MemoryLengthStack(4).SmartfishStack(k).ExtinctRate = PIdelta/(2 * trialNum);
        end
    end
    
