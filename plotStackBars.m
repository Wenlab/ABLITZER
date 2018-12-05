y = zeros(4,4);
for k = 1:4
    FishStack = MemLenStat_GCaMP(k).SmartfishStack; 
    for n = 1:length(FishStack)
        if FishStack(n).MemoryLength > 0 && FishStack(n).MemoryLength < 400
            y(k,1) = y(k,1) + 1;
        elseif FishStack(n).MemoryLength >= 400 && FishStack(n).MemoryLength < 800
            y(k,2) = y(k,2) + 1;
        elseif FishStack(n).MemoryLength >= 800 && FishStack(n).MemoryLength <= 1000
            y(k,3) = y(k,3) + 1;
        elseif FishStack(n).MemoryLength == 1080;
            y(k,4) = y(k,4) + 1;
        end
    end
end

x = categorical({'RGB0','RGB32','RGB43','RGB64'});

h = bar(x,y,'stacked');
for n = 1:4
    h(n).BarWidth = 0.5;
end

xlabel('CS Pattern');
ylabel('Count');
legend('0~400','400~800','800~1000','Not ectinct');


