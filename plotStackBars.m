y = zeros(3,3);
MlStack = Memory
FishStack = MemoryLengthStack(3).SmartfishStack;
ML = cat(1,FishStack.MemoryLength);
meanML = round(mean(ML));
for n = 1:length(FishStack)
    if FishStack(n).MemoryLength >= 240 && FishStack(n).MemoryLength <= 360
        y(1) = y(1) + 1;
    elseif FishStack(n).MemoryLength >= 480 && FishStack(n).MemoryLength <= 720
        y(2) = y(2) + 1;
    elseif FishStack(n).MemoryLength >= 840 && FishStack(n).MemoryLength <= 960
        y(3) = y(3) + 1;
    elseif FishStack(n).MemoryLength == 1080
        y(4) = y(4) + 1;
    end
end
x = 300:300:1200;
h = bar(x,y);
h.BarWidth = 0.5;
h.FaceColor = [0 0 0];

line([meanML,meanML],ylim,'Color','m');
ticks = get(gca,'XTick');
ticklabels = {'240~360','480~720','840~960','Not ectinct'};
[ticks,idx] = sort(ticks);
ticklabels = ticklabels(idx);
set(gca,'Xtick',ticks,'XTickLabel',ticklabels);
StrMean = mat2str(meanML);


xlabel('Memory Length(s)');
ylabel('Count');