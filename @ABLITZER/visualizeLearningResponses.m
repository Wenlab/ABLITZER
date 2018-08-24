% plot PIs of an entire group to see whether there's
% any statistical significance.
%
% INPUT:
%   idxExpGroup: the index of experiment group data in FishGroup struct
%   idxCtrlGroup: the index of control group data in FishGroup struct
%   metricType: which metric the user wants to plot. (PItime, PIturn or
%   PIshock?)
%
%   TODO: put contrain on pairing experiment data with control data
%       currently, they are automatically in the same order due to
%       alphabetic reason.
function visualizeLearningResponses(obj,idxExpGroup,idxCtrlGroup,metricType)
    if (nargin == 3) % default plot type is based on type
        metricType = "time";
    end
    fishStack = obj.FishStack;
    idxExpData = obj.FishGroups(idxExpGroup).Data;
    idxCtrlData = obj.FishGroups(idxCtrlGroup).Data;

    expData = fishStack(idxExpData);
    ctrlData = fishStack(idxCtrlData);

    % Pairing check (temporal)
    if length(expData) ~= length(ctrlData)
        error('Data from experiment group is not paired with the control group.');
    end

    qualThre = 0.95;
    PIs = []; % Performance Index from control and experiment group
    for i=1:length(expData)
        % Eliminate fish whose dataQuality is lower than qualThre (0.95)
        % once expData/ctrlData eliminated, both data eliminated
        if (expData(i).Res.DataQuality < qualThre) || (ctrlData(i).Res.DataQuality < qualThre)
            fprintf('Invalid Data:\n DataQuality is lower than 0.95.\n'); continue;
        end
        if contains(metricType,"time",'IgnoreCase',true)
            PIdata = cat(2,ctrlData(i).Res.PItime.PIfish,expData(i).Res.PItime.PIfish);
        elseif contains(metricType,"turn",'IgnoreCase',true)
            PIdata = cat(2,ctrlData(i).Res.PIturn.PIfish,expData(i).Res.PIturn.PIfish);
        end

        PIs = cat(1,PIs, PIdata);
    end

    if isempty(PIs)
        fprintf('No valid data to plot\n');
        return
    end

    figure;

    colors = 0.8*ones(6,3);%[0.5,0,0;0,0.5,0;0,0,0.5;0.5,0.5,0;0.5,0,0.5;0,0.5,0.5];
    labels = {'Baseline(C)','Training(C)','Test(C)',...
        'Baseline','Training','Test'};
    UnivarScatter(PIs,'Label',labels,'Whiskers','lines','PointStyle','.',...
        'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[1,1,1],'PointSize',20,...
        'SEMColor',colors/1.5,'StdColor',[1,1,1]);
    set(gca,'YGrid','on'); % add yGrid to help compare data
    if contains(metricType,"time",'IgnoreCase',true)
        titleStr = sprintf('Non-CS Area Time Proportion (%s)-%d dpf',expData(1).Strain,expData(1).Age);
    elseif contains(metricType,"turn",'IgnoreCase',true)
        titleStr = sprintf('Turning performance index (%s)-%d dpf',expData(1).Strain,expData(1).Age);
    end

    title(titleStr,'FontSize',14);
    ylim([0,1]);
    str = sprintf('N = %d\n',size(PIs,1));
    text(0.1,0.9,str);

    % Add formatted T-test and significance bar, minimum principle
    sigSyms = ["n.s.",... % P > 0.05
                "*",...   % P < 0.05
                "**",...  % P < 0.01
                "***",... % P < 0.001
                "****"];  % P < 0.0001 % occassionally use

   % control group: compare mean of PIs between Baseline(C) and Test(C)
   [~,p] = ttest(PIs(:,1),PIs(:,3));
   line([1,3],[0.3,0.3],'Color',[0,0,0]);
   if p > 0.05 % n.s.
       text(2,0.25,'n.s.','FontSize',14);
   elseif p < 0.05 % "*"
       text(2,0.25,'*','FontSize',20);
   elseif p < 0.01 % "**"
       text(2,0.25,'**','FontSize',20);
   elseif p < 0.001 % "***"
       text(2,0.25,'***','FontSize',20);
   elseif p < 0.0001 % "****"
       text(2,0.25,'****','FontSize',20);
   end

   % experiment group: compare mean of PIs between Baseline and Test
   [~,p] = ttest(PIs(:,4),PIs(:,6));
   line([4,6],[0.3,0.3],'Color',[0,0,0]);
   if p > 0.05 % n.s.
       text(5,0.25,'n.s.','FontSize',14);
   elseif p < 0.05 % "*"
       text(5,0.25,'*','FontSize',20);
   elseif p < 0.01 % "**"
       text(5,0.25,'**','FontSize',20);
   elseif p < 0.001 % "***"
       text(5,0.25,'***','FontSize',20);
   elseif p < 0.0001 % "****"
       text(5,0.25,'****','FontSize',20);
   end



end
