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


function [OLcontrol,OLexp,p] = plotPIs(obj,...ABLITZAER object
numGroups,... % 1: exp only; 2: with self-control; 3: with unpaired control
metric)    % "positional" or "turning"

output = obj.outputFeatures;
obj.classifyFish("ExpTask");
if numGroups > length(obj.FishGroups)
    fprintf('No data available for the entered numGroups\n');
    fprintf('Please enter 1 or 2 for the numGroups');
    exit(0);
end

tasks = cat(1,output.Task);
if numGroups == 1 % plot the experiment group only
    idxExp = find(strcmp(tasks,'OLexp')); 
    if strcmpi(metric,"positional")
        PIs = cat(2,output(idxExp).PITime_Baseline,output(idxExp).PITime_Test);
    elseif strcmpi(metric,"turning")
        PIs = cat(2,output(idxExp).PITurn_Baseline,output(idxExp).PITurn_Test);
    else
        error('Please choose "positional" or "turning" as the metric');
    end
    p = pairedSignificanceTest(PIs(:,1),PIs(:,2));
    
elseif numGroups == 2 % plot the experiment group with the self-control group
    idxExp = find(strcmp(tasks,'OLexp')); 
    idxCtrl = find(strcmp(tasks,'OLcontrol')); 
    if strcmpi(metric,"positional")
        PIs = cat(2,output(idxCtrl).PITime_Baseline,output(idxCtrl).PITime_Test,...
            output(idxExp).PITime_Baseline,output(idxExp).PITime_Test);
    elseif strcmpi(metric,"turning")
        PIs = cat(2,output(idxCtrl).PITurn_Baseline,output(idxCtrl).PITurn_Test,...
            output(idxExp).PITurn_Baseline,output(idxExp).PITurn_Test);
    else
        error('Please choose "positional" or "turning" as the metric');
    end
    
    
elseif numGroups == 3 % plot all groups
    idxExp = find(strcmp(tasks,'OLexp')); 
    idxCtrl = find(strcmp(tasks,'OLcontrol')); 
    idxUP = find(strcmp(tasks,'UPexp')); 
    if strcmpi(metric,"positional")
        PIs = cat(2,output(idxCtrl).PITime_Baseline,output(idxCtrl).PITime_Test,...
            output(idxExp).PITime_Baseline,output(idxExp).PITime_Test,...
            output(idxUP).PITime_Baseline,output(idxUP).PITime_Test);
    elseif strcmpi(metric,"turning")
        PIs = cat(2,output(idxCtrl).PITurn_Baseline,output(idxCtrl).PITurn_Test,...
            output(idxExp).PITurn_Baseline,output(idxExp).PITurn_Test,...
            output(idxUP).PITurn_Baseline,output(idxUP).PITurn_Test);
    else
        error('Please choose "positional" or "turning" as the metric');
    end
    
    
else
    error('The entered numGroups is invalid');
end


[x,h] = sigStarBarPlot(PIs);




OLexp = obj.outputFeatures(obj,"OLexp");
OLcontrol = obj.outputFeatures(obj,"OLcontrol");
PIsOL = [OLexp.PITime_Baseline;OLexp.PITime_Test;OLcontrol.PITime_Baseline;OLcontrol.PITime_Test;...
          OLexp.PITurn_Baseline;OLexp.PITurn_Test;OLcontrol.PITurn_Baseline;OLcontrol.PITurn_Test];

SemOL = calcSem(PIsOL);
MeanOL = mean(PIsOL,2)';
XTickLabel = ["Self-control","Experiment","Unpaired control"];
if string(metric) == "positional"
    idx = 1;
    Ylabel = "Positional Index";
elseif string(metric) == "turning"
    idx = 2;
    Ylabel = "Turning Index";
end
    if numGroups==1
      y = [MeanOL(1+4*(idx-1)),MeanOL(2+4*(idx-1))];
      Sem = [SemOL(1+4*(idx-1)),SemOL(2+4*(idx-1))];
      plotPairBar(y,Sem,XTickLabel,Ylabel);
      p = significanceTest(PIsOL(1+4*(idx-1),:),PIsOL(2+4*(idx-1),:),2,4,0.8);

    elseif numGroups==2
      y = [MeanOL(3+4*(idx-1)),MeanOL(4+4*(idx-1)),MeanOL(1+4*(idx-1)),MeanOL(2+4*(idx-1))];
      Sem = [SemOL(3+4*(idx-1)),SemOL(4+4*(idx-1)),SemOL(1+4*(idx-1)),SemOL(2+4*(idx-1))];
      plotPairBar(y,Sem,XTickLabel,Ylabel);
      p(1) = significanceTest(PIsOL(3+4*(idx-1),:),PIsOL(4+4*(idx-1),:),1,2,0.8);
      p(2) = significanceTest(PIsOL(1+4*(idx-1),:),PIsOL(2+4*(idx-1),:),4,5,0.8);

    else
      Unpaired = output_task(obj,"UPexp");
      PIsUP = [Unpaired.PITime_Baseline;Unpaired.PITime_Test;Unpaired.PITurn_Baseline;Unpaired.PITurn_Test];
      SemUP = calcSem(PIsUP);
      MeanUP = mean(PIsUP,2)';
      y = [MeanOL(3+4*(idx-1)),MeanOL(4+4*(idx-1)),MeanOL(1+4*(idx-1)),MeanOL(2+4*(idx-1)),MeanUP(1+2*(idx-1)),MeanUP(2+2*(idx-1))];
      Sem = [SemOL(3+4*(idx-1)),SemOL(4+4*(idx-1)),SemOL(1+4*(idx-1)),SemOL(2+4*(idx-1)),SemUP(1+2*(idx-1)),SemUP(2+2*(idx-1))];
      plotPairedBar(y,Sem,XTickLabel,Ylabel);
      p(1) = significanceTest(PIsOL(3+2*(idx-1),:),PIsOL(4+2*(idx-1),:),1,2,0.8);
      p(2) = significanceTest(PIsOL(1+2*(idx-1),:),PIsOL(2+2*(idx-1),:),4,5,0.8);
      p(3) = significanceTest(PIsUP(1+2*(idx-1),:),PIsUP(2+2*(idx-1),:),7,8,0.8);
   end
    legend('Before training','After training');


end


function Sem = calcSem(PIs)
num = length(PIs(1,:));
Sem = std(PIs,1,2)'/sqrt(num);
end
