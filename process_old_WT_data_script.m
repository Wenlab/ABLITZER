% process old WT data
pathName = 'F:\Project-Operant Learning in Larval Zebrafish\ExpDataSet\ABLITZER_DATA\';
dateList = ["20180513",...
            "20180514",...
            "20180515",...
            "20180516"
            ];

for i=1:length(dateList)
    dateStr = char(dateList(i));
    obj = ABLITZER;
    obj.processOneDayYamls('F:\FishExpData\operantLearning\',dateStr);
    fill_up_exp_info(obj);
    fish = obj.FishStack(1);
    saveMatName = [pathName,dateStr,'_',num2str(fish.Age),'dpf_', ...
        char(fish.Strain),'_OL_',char(fish.CSpattern),'.mat'];
    save(saveMatName,'obj');
    
end

function fill_up_exp_info(obj)
% fill up exp info
CSpattern = "redBlackCheckerboard";
numFish = length(obj.FishStack);
for i = 1:numFish
    fish = obj.FishStack(i);
    ID = char(fish.ID);
    if (ID(3) == '1') || (ID(3) == '4')
        fish.Arena = 1;
    elseif (ID(3) == '2') || (ID(3) == '5')
        fish.Arena = 2;
    elseif (ID(3) == '3') || (ID(3) == '6')
        fish.Arena = 3;
    end
    fish.CSpattern = CSpattern;
    
end
end

