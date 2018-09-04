function [output_OLcontrol,output_OLexp,output_Unpaired,p] = plot_bar_SEU(a)
  % a is a matrix: "n*1 ABLITZER";
  for i=1:length(a)
      remove_invalid_data_pair(a(i));
  end
  output_OLcontrol = output_task(a,"OLcontrol");
  output_OLexp = output_task(a,"OLexp");
  output_Unpaired = output_task(a,"UPexp");

% plot the bar chart of PITime
y11=[mean(output_OLcontrol.PITime_Baseline),mean(output_OLexp.PITime_Baseline),mean(output_Unpaired.PITime_Baseline)];
y12=[mean(output_OLcontrol.PITime_Test),mean(output_OLexp.PITime_Test),mean(output_Unpaired.PITime_Test)];

y1_std=[std(output_OLcontrol.PITime_Baseline),std(output_OLcontrol.PITime_Test),...
      std(output_OLexp.PITime_Baseline),std(output_OLexp.PITime_Test),...
      std(output_Unpaired.PITime_Baseline),std(output_Unpaired.PITime_Test)];
XTickLabel = ["Self-control","Experiment","Unpaired control"];
plotpairbar(y11,y12,y1_std,XTickLabel,"Poisitional Index");

p.time(1) = significanceTest(output_OLcontrol.PITime_Baseline,output_OLcontrol.PITime_Test,1);
p.time(2) = significanceTest(output_OLexp.PITime_Baseline,output_OLexp.PITime_Test,4);
p.time(3) = significanceTest(output_Unpaired.PITime_Baseline,output_Unpaired.PITime_Test,7);
legend('Before training','After training');

% plot the bar chart of PITurn
y21=[mean(output_OLcontrol.PITurn_Baseline),mean(output_OLexp.PITurn_Baseline),mean(output_Unpaired.PITurn_Baseline)];
y22=[mean(output_OLcontrol.PITurn_Test),mean(output_OLexp.PITurn_Test),mean(output_Unpaired.PITurn_Test)];

y2_std=[std(output_OLcontrol.PITurn_Baseline),std(output_OLcontrol.PITurn_Test),...
      std(output_OLexp.PITurn_Baseline),std(output_OLexp.PITurn_Test),...
      std(output_Unpaired.PITurn_Baseline),std(output_Unpaired.PITurn_Test)];


plotpairbar(y21,y22,y2_std,XTickLabel,"Turning Index");

p.turn(1) = significanceTest(output_OLcontrol.PITurn_Baseline,output_OLcontrol.PITurn_Test,1);
p.turn(2) = significanceTest(output_OLexp.PITurn_Baseline,output_OLexp.PITurn_Test,4);
p.turn(3) = significanceTest(output_Unpaired.PITurn_Baseline,output_Unpaired.PITurn_Test,7);
legend('Before training','After training');
end
