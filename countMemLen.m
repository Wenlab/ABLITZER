% count learners' memory lengths

aObj = ABLITZER;
aObj.loadMats([],'F:\FishData\',["OL","RGB96"]);
%% Plot distance to centerline for each fish in the experiment group
h = figure;
figNum = h.Number;
aObj.classifyFish("ExpType");
idxExp = aObj.FishGroups(2).Data;
SmartfishStack = struct('fishAge',NaN,'fishID','','MemoryLength',NaN,'ExtinctRate',NaN);
MemoryLengthStack = struct('CSPattern','','SmartfishStack',[]);
MemoryLengthStack(1).CSPattern = "RGB32";
MemoryLengthStack(2).CSPattern = "RGB43";
MemoryLengthStack(3).CSPattern = "RGB64";
MemoryLengthStack(4).CSPattern = "RGB96";
for i = 1:length(idxExp)
    
    idx = idxExp(i);
    fish = aObj.FishStack(idx);
    [h, p, extincTime] = fish.sayIfLearned;
    if h == 1
        if fish.CSpattern == "RGB32"
            k = 1;
        elseif fish.CSpattern == "RGB43"
            k = 2;
        elseif fish.CSpattern == "RGB64"
            k = 3;
        elseif fish.CSpattern == "RGB96"
            k = 4;
        end
        l = length(MemoryLengthStack(k).SmartfishStack);
        MemoryLengthStack(k).SmartfishStack(l+1).fishAge = fish.Age;
        MemoryLengthStack(k).SmartfishStack(l+1).fishID = fish.ID;
        MemoryLengthStack(k).SmartfishStack(l+1).MemoryLength = extincTime;
    end
end
