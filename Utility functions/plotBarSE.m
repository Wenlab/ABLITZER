function [OLcontrol,OLexp,p] = plotBarSE(a)
  % a is a matrix: "n*1 ABLITZER";
  for i=1:length(a)
      remove_invalid_data_pair(a(i));
  end
OLcontrol = output_task(a,"OLcontrol");
OLexp = output_task(a,"OLexp");

PIs=[OLcontrol.PITime_Baseline;OLcontrol.PITime_Test;...
      OLexp.PITime_Baseline;OLexp.PITime_Test;...
      OLcontrol.PITurn_Baseline;OLcontrol.PITurn_Test;...
      OLexp.PITurn_Baseline;OLexp.PITurn_Test];

[Mean,Sem] = calcMeanSem(PIs);

XTickLabel = ["Self-control","Experiment"];
plotPairBar(Mean(1,:),Mean(2,:),Sem(1:4),XTickLabel,"Positional Index");
p.time(1) = significanceTest(PIs(1,:),PIs(2,:),1,2,0.8);
p.time(2) = significanceTest(PIs(3,:),PIs(4,:),4,5,0.8);
legend('Before training','After training');


plotPairBar(Mean(3,:),Mean(4,:),Sem(5:8),XTickLabel,"Turning Index");
p.turn(1) = significanceTest(PIs(5,:),PIs(6,:),1,2,0.8);
p.turn(2) = significanceTest(PIs(7,:),PIs(8,:),4,5,0.8);
legend('Before training','After training');
end


function [Mean2,Sem] = calcMeanSem(PIs)
Mean = mean(PIs,2);
Mean2 = [Mean(1),Mean(3);Mean(2),Mean(4);...        %PITimeBaselineMean;PITimeTestMean;
         Mean(5),Mean(7);Mean(6),Mean(8)];        %PITurnBaselineMean;PITurnTestMean;
[~,num] = size(PIs)
Sem = std(PIs,1,2)/sqrt(num);
end
