%  Filename: plotPIs.m (methods of ABLITZER class)
%  Abstract:
%        Plot performance index (positional/turning) of different groups (1. exp only; 2. with self-control; 3. with unpaired control)
%
%   SYNTAX:
%        1. obj.plotPIs(numGroups,metrics)
%        2. plotPIs(obj,numGroups,metrics)
%
% - plotPIs
%      - ABLITZER method
%      -arg1: metric type (positional/turning/shock)
%      -arg2: (number of arguments) which groups to plot (1. exp only; 2. with self-control; 3. with unpaired control)
%  TODO:


function [sigMat,PIs] = plotPIs(obj,...ABLITZAER object
numGroups,... % 1: exp only; 2: with self-control; 3: with unpaired control
metric)    % "positional" or "turning"

output = obj.outputFeatures;
obj.classifyFish("ExpTask");
if numGroups > length(obj.FishGroups)
    fprintf('No data available for the entered numGroups\n');
    fprintf('Please enter 1 or 2 for the numGroups');
    return;
end

tasks = cat(1,output.Task);
if numGroups == 1 % plot the experiment group only
    idxExp = find(contains(tasks,'exp','IgnoreCase',true)); 
    if strcmpi(metric,"positional")
        PIs = cat(2,cat(1,output(idxExp).PITime_Baseline),cat(1,output(idxExp).PITime_Test));
        yLab = "Positional Index";
    elseif strcmpi(metric,"turning")
        PIs = cat(2,cat(1,output(idxExp).PITurn_Baseline),cat(1,output(idxExp).PITurn_Test));
        yLab = "Turning Index";
    else
        error('Please choose "positional" or "turning" as the metric');
    end
    xtLabels = ["Experiment"];
    
elseif numGroups == 2 % plot the experiment group with the self-control group
    idxExp = find(contains(tasks,'exp','IgnoreCase',true)); 
    idxCtrl = find(contains(tasks,'control','IgnoreCase',true)); 
    if strcmpi(metric,"positional")
        PIs = cat(2,cat(1,output(idxCtrl).PITime_Baseline),cat(1,output(idxCtrl).PITime_Test),...
            cat(1,output(idxExp).PITime_Baseline),cat(1,output(idxExp).PITime_Test));
        yLab = "Positional Index";
    elseif strcmpi(metric,"turning")
        PIs = cat(2,cat(1,output(idxCtrl).PITurn_Baseline),cat(1,output(idxCtrl).PITurn_Test),...
            cat(1,output(idxExp).PITurn_Baseline),cat(1,output(idxExp).PITurn_Test));
        yLab = "Turning Index";
    else
        error('Please choose "positional" or "turning" as the metric');
    end
    xtLabels = ["Self-control","Experiment"];
    
elseif numGroups == 3 % plot all groups
    idxExp = find(strcmp(tasks,'OLexp')); 
    idxCtrl = find(strcmp(tasks,'OLcontrol')); 
    idxUP = find(strcmp(tasks,'UPexp')); 
    if strcmpi(metric,"positional")
        yLab = "Positional Index";
        PIs = cat(2,cat(1,output(idxCtrl).PITime_Baseline),cat(1,output(idxCtrl).PITime_Test),...
            cat(1,output(idxExp).PITime_Baseline),cat(1,output(idxExp).PITime_Test),...
            cat(1,output(idxUP).PITime_Baseline),cat(1,output(idxUP).PITime_Test));
    elseif strcmpi(metric,"turning")
        PIs = cat(2,cat(1,output(idxCtrl).PITurn_Baseline),cat(1,output(idxCtrl).PITurn_Test),...
            cat(1,output(idxExp).PITurn_Baseline),cat(1,output(idxExp).PITurn_Test),...
            cat(1,output(idxUP).PITurn_Baseline),cat(1,output(idxUP).PITurn_Test));
        yLab = "Turning Index";
    else
        error('Please choose "positional" or "turning" as the metric');
    end
    
    xtLabels = ["Self-control","Experiment","Unpaired control"];
else
    error('The entered numGroups is invalid');
end



% mean and variance calculation
numCols = size(PIs,2);
M = mean(PIs,1);
err = std(PIs,1,1)/sqrt(size(PIs,1));

M = transpose(reshape(M,[2,numCols/2]));
err = transpose(reshape(err,[2,numCols/2]));

% significance calculation
sigMat = reshape(1:numCols,2,numCols/2);
sigMat = cat(2,transpose(sigMat),zeros(numCols/2,1));
for i = 1:numCols/2
    [~,p] = ttest(PIs(:,2*i-1),PIs(:,2*i));  
    sigMat(i,3) = p;
end



barPlot(M,'errorbar',err,'significance',sigMat,'xticklabels',xtLabels,'ylabel',yLab);


end
