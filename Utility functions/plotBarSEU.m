function [OLcontrol,OLexp,Unpaired,p] = plotBarSEU(a)
% S: self-control; E: experiment group; U: unpaired-control group
  % a is a matrix: "n*1 ABLITZER";
  for i=1:length(a)
      remove_invalid_data_pair(a(i));
  end
  OLcontrol =output_task(a,"OLcontrol");
  OLexp = output_task(a,"OLexp");
  Unpaired = output_task(a,"UPexp");

PITime.OL = [OLcontrol.PITime_Baseline;OLcontrol.PITime_Test;OLexp.PITime_Baseline;OLexp.PITime_Test];
PITime.UP = [Unpaired.PITime_Baseline;Unpaired.PITime_Test];

[MeanTime,SemTime] = calcMeanSem(PITime);
XTickLabel = ["Self-control","Experiment","Unpaired control"];
plotPairBar(MeanTime(1,:),MeanTime(2,:),SemTime,XTickLabel,"Positional Index");

p.time(1) = significanceTest(PITime.OL(1,:),PITime.OL(2,:),1,2,0.8);
p.time(2) = significanceTest(PITime.OL(3,:),PITime.OL(4,:),4,5,0.8);
p.time(3) = significanceTest(PITime.UP(1,:),PITime.UP(2,:),7,8,0.8);
legend('Before training','After training');

% plot the bar chart of PITurn
PITurn.OL = [OLcontrol.PITurn_Baseline;OLcontrol.PITurn_Test;OLexp.PITurn_Baseline;OLexp.PITurn_Test];
PITurn.UP = [Unpaired.PITurn_Baseline;Unpaired.PITurn_Test];

[MeanTurn,SemTurn] = calcMeanSem(PITurn);
XTickLabel = ["Self-control","Experiment","Unpaired control"];
plotPairBar(MeanTurn(1,:),MeanTurn(2,:),SemTurn,XTickLabel,"Turning Index");

p.turn(1) = significanceTest(PITurn.OL(1,:),PITurn.OL(2,:),1,2,0.8);
p.turn(2) = significanceTest(PITurn.OL(3,:),PITurn.OL(4,:),4,5,0.8);
p.turn(3) = significanceTest(PITurn.UP(1,:),PITurn.UP(2,:),7,8,0.8);
legend('Before training','After training');
end




function [Mean,Sem] = calcMeanSem(PI)
  Mean(1,:) = [mean(PI.OL(1,:)),mean(PI.OL(3,:)),mean(PI.UP(1,:))];
  Mean(2,:) = [mean(PI.OL(2,:)),mean(PI.OL(4,:)),mean(PI.UP(2,:))];

  Sem=[std(PI.OL(1,:),1)/sqrt(length(PI.OL(1,:))),std(PI.OL(2,:),1)/sqrt(length(PI.OL(2,:))),...
        std(PI.OL(3,:),1)/sqrt(length(PI.OL(3,:))),std(PI.OL(4,:),1)/sqrt(length(PI.OL(4,:))),...
        std(PI.UP(1,:),1)/sqrt(length(PI.UP(1,:))),std(PI.UP(2,:),1)/sqrt(length(PI.UP(2,:)))];

end
