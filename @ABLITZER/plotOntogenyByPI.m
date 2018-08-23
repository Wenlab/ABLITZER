% plot performance versus fish age
% Here, we use the substraction of PI in training with PI in baseline as
% the characteristic PI for fish at the same age
function  plotOntogenyByPI(obj,metricType)
% filter invalid data
obj = filter_invalid_data(obj);

% correct 10 dpf age error
obj.classifyFishByKeys("Age");
Names = cat(1,obj.FishGroups.Name);

idxN = find(Names == "1");
if ~isempty(idxN)
    idx1 = obj.FishGroups(idxN).Data;
    for i = 1:length(idx1)
        idx = idx1(i);
        obj.FishStack(idx).Age = 10;
    end

    % re-classify groups
    obj.classifyFishByKeys("Age");
    Names = cat(1,obj.FishGroups.Name);
end

ages = str2double(Names);
[agesSorted,IDX] = sort(ages);

PIs = [];
numGroups = length(obj.FishGroups);
labels = cell(1,numGroups);
for i=1:numGroups
    labels{1,i} = num2str(agesSorted(i));
    idx = IDX(i);
    fishIdx = obj.FishGroups(idx).Data;

    numFish = length(fishIdx);
    pIdx = [];
    for n = 1:numFish
        if contains(obj.FishStack(fishIdx(n)).ExpType,"control",'IgnoreCase',true)
            continue;
        end
        if contains(metricType,"time",'IgnoreCase',true)
            pIdx = cat(1,pIdx,obj.FishStack(fishIdx(n)).Res.PItime(2).PIfish - ...
                obj.FishStack(fishIdx(n)).Res.PItime(1).PIfish);
        elseif contains(metricType,"turn",'IgnoreCase',true)
            pIdx = cat(1,pIdx,obj.FishStack(fishIdx(n)).Res.PIturn(2).PIfish - ...
                obj.FishStack(fishIdx(n)).Res.PIturn(1).PIfish);
        end


    end
    PIs = nancat(2,PIs,pIdx);

end

figure;

colors = 0.8*ones(6,3);
UnivarScatter(PIs,'Label',labels,'Whiskers','lines','PointStyle','.',...
        'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[1,1,1],'PointSize',20,...
        'SEMColor',colors/1.5,'StdColor',[1,1,1]);
set(gca,'YGrid','on'); % add yGrid to help compare data
ylim([-0.5,0.5]);
xlabel('Ages (dpf)');
ylabel('PI (in training minus in baseline)');
if contains(metricType,"time",'IgnoreCase',true)
    titleStr = 'Performance develops with age based on non-CS time proportion';
elseif contains(metricType,"turn",'IgnoreCase',true)
    titleStr = 'Performance develops with age based on turning events';
end

title(titleStr,'FontSize',14);
maxN = size(PIs,1);
minN = maxN - max(sum(isnan(PIs),1));
str = sprintf('N = %d - %d per day \n',minN, maxN);
text(0.8,0.4,str);





end

function obj = filter_invalid_data(obj)
    qualThre = 0.95;
    badIndices = []; % store bad index pairs
    % all prepared dataset would be paired automatically
    % due to the classification algorithm
    obj.classifyFishByKeys("ExpType");
    numFish = length(obj.FishGroups(1).Data);
    idxCtrl = obj.FishGroups(1).Data;
    idxExp = obj.FishGroups(2).Data;
    for i=1:numFish
        idx1 = idxCtrl(i);
        idx2 = idxExp(i);
        if (obj.FishStack(idx1).Res.DataQuality < qualThre) || ...
              (obj.FishStack(idx2).Res.DataQuality < qualThre)
          badIndices = cat(2,badIndices,[idx1,idx2]);
        end

    end

    obj.FishStack(badIndices) = [];



end
