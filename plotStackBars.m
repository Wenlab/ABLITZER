y = zeros(4,3);
% for k = 1:4
%     FishStack = MemLenStat_GCaMP(k).SmartfishStack; 
%     for n = 1:length(FishStack)
%         if FishStack(n).MemoryLength > 0 && FishStack(n).MemoryLength < 500
%             y(k,1) = y(k,1) + 1;
%         elseif FishStack(n).MemoryLength >= 500 && FishStack(n).MemoryLength < 1000
%             y(k,2) = y(k,2) + 1;
%         elseif FishStack(n).MemoryLength == 1080
%             y(k,3) = y(k,3) + 1;
%         end
%     end
% end
 FishStack = MemLenStat_WT.PureBlack; 
    for n = 1:length(FishStack)
        if FishStack(n).MemoryLength > 0 && FishStack(n).MemoryLength < 500
            y(1,1) = y(1,1) + 1;
        elseif FishStack(n).MemoryLength >= 500 && FishStack(n).MemoryLength < 1000
            y(1,2) = y(1,2) + 1;
        elseif FishStack(n).MemoryLength == 1080
            y(1,3) = y(1,3) + 1;
        end
    end
 FishStack = MemLenStat_WT.RGB32; 
    for n = 1:length(FishStack)
        if FishStack(n).MemoryLength > 0 && FishStack(n).MemoryLength < 500
            y(2,1) = y(2,1) + 1;
        elseif FishStack(n).MemoryLength >= 500 && FishStack(n).MemoryLength < 1000
            y(2,2) = y(2,2) + 1;
        elseif FishStack(n).MemoryLength == 1080
            y(2,3) = y(2,3) + 1;
        end
    end
    FishStack = MemLenStat_WT.RGB43; 
    for n = 1:length(FishStack)
        if FishStack(n).MemoryLength > 0 && FishStack(n).MemoryLength < 500
            y(3,1) = y(3,1) + 1;
        elseif FishStack(n).MemoryLength >= 500 && FishStack(n).MemoryLength < 1000
            y(3,2) = y(3,2) + 1;
        elseif FishStack(n).MemoryLength == 1080
            y(3,3) = y(3,3) + 1;
        end
    end
    FishStack = MemLenStat_WT.RGB64; 
    for n = 1:length(FishStack)
        if FishStack(n).MemLen > 0 && FishStack(n).MemoryLength < 500
            y(4,1) = y(4,1) + 1;
        elseif FishStack(n).MemoryLength >= 500 && FishStack(n).MemoryLength < 1000
            y(4,2) = y(4,2) + 1;
        elseif FishStack(n).MemoryLength == 1080
            y(4,3) = y(4,3) + 1;
        end
    end
x = categorical({'RGB0','RGB32','RGB43','RGB64'});

h = bar(x,y,'stacked');
for n = 1:3
    h(n).BarWidth = 0.5;
end


ylabel('Count');
legend('0~500','500~1000','Not extinct');


