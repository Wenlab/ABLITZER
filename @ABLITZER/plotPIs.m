%  Filename: plotPIs.m (methods of ABLITZER class��
%  Abstract:
%        Plot performance index (positional/turning) of different groups (1. exp only; 2. with self-control; 3. with unpaired control)
%
%   SYNTAX:
%        1. obj.plotPIs(flag1,flag2)
%        2. plotPIs(obj,flag1,flag2)
%
% - plotPIs
%      - ABLITZER method
%      -arg1: metric type (positional/turning/shock)
%      -arg2: (number of arguments) which groups to plot (1. exp only; 2. with self-control; 3. with unpaired control)
%  TODO:


function [OLcontrol,OLexp,p] = plotPIs(obj,...ABLITZAER object
flag1,... % 1: exp only; 2: with self-control; 3: with unpaired control
flag2)    % "positional" or "turning"

OLexp = output_task(obj,"OLexp");
OLcontrol = output_task(obj,"OLcontrol");
PIsOL = [OLexp.PITime_Baseline;OLexp.PITime_Test;OLcontrol.PITime_Baseline;OLcontrol.PITime_Test;...
          OLexp.PITurn_Baseline;OLexp.PITurn_Test;OLcontrol.PITurn_Baseline;OLcontrol.PITurn_Test];

[MeanOL,SemOL] = calcMeanSem(PIsOL);
XTickLabel = ["Self-control","Experiment","Unpaired control"];
if flag2=="positional"
    idx = 1;
    Ylabel = "Positional Index";
else
    idx = 2;
    Ylabel = "Turning Index";
end
    if flag1==1
      y = [MeanOL(1+4*(idx-1)),MeanOL(2+4*(idx-1))];
      Sem = [SemOL(1+4*(idx-1)),SemOL(2+4*(idx-1))];
      plotPairBar(y,Sem,XTickLabel,Ylabel);
      p = significanceTest(PIsOL(1+4*(idx-1),:),PIsOL(2+4*(idx-1),:),2,4,0.8);

    elseif flag1==2
      y = [MeanOL(3+4*(idx-1)),MeanOL(4+4*(idx-1)),MeanOL(1+4*(idx-1)),MeanOL(2+4*(idx-1))];
      Sem = [SemOL(3+4*(idx-1)),SemOL(4+4*(idx-1)),SemOL(1+4*(idx-1)),SemOL(2+4*(idx-1))];
      plotPairBar(y,Sem,XTickLabel,Ylabel);
      p(1) = significanceTest(PIsOL(3+4*(idx-1),:),PIsOL(4+4*(idx-1),:),1,2,0.8);
      p(2) = significanceTest(PIsOL(1+4*(idx-1),:),PIsOL(2+4*(idx-1),:),4,5,0.8);

    else
        Unpaired = output_task(obj,"UPexp");
       PIsUP = [Unpaired.PITime_Baseline;Unpaired.PITime_Test;Unpaired.PITurn_Baseline;Unpaired.PITurn_Test];
       [MeanUP,SemUP] = calcMeanSem(PIsUP);
      y = [MeanOL(3+4*(idx-1)),MeanOL(4+4*(idx-1)),MeanOL(1+4*(idx-1)),MeanOL(2+4*(idx-1)),MeanUP(1+2*(idx-1)),MeanUP(2+2*(idx-1))];
      Sem = [SemOL(3+4*(idx-1)),SemOL(4+4*(idx-1)),SemOL(1+4*(idx-1)),SemOL(2+4*(idx-1)),SemUP(1+2*(idx-1)),SemUP(2+2*(idx-1))];
      plotPairBar(y,Sem,XTickLabel,Ylabel);
      p(1) = significanceTest(PIsOL(3+2*(idx-1),:),PIsOL(4+2*(idx-1),:),1,2,0.8);
      p(2) = significanceTest(PIsOL(1+2*(idx-1),:),PIsOL(2+2*(idx-1),:),4,5,0.8);
      p(3) = significanceTest(PIsUP(1+2*(idx-1),:),PIsUP(2+2*(idx-1),:),7,8,0.8);
   end
    legend('Before training','After training');


end


function [Mean,Sem] = calcMeanSem(PIs)
num = length(PIs(1,:));
Mean = mean(PIs,2)';
Sem = std(PIs,1,2)'/sqrt(num);
end
