function [output_OLcontrol,output_OLexp,p] = plot_bar_SE(a)
  % a is a matrix: "n*1 ABLITZER";
  for i=1:length(a)
      remove_invalid_data_pair(a(i));
  end
  output_OLcontrol = output_task(a,"OLcontrol");
  output_OLexp = output_task(a,"OLexp");


% plot the bar chart of PITime
y11=[mean(output_OLcontrol.PITime_Baseline),mean(output_OLexp.PITime_Baseline)];
y12=[mean(output_OLcontrol.PITime_Test),mean(output_OLexp.PITime_Test)];

y1_std=[std(output_OLcontrol.PITime_Baseline,1),std(output_OLcontrol.PITime_Test,1),...
      std(output_OLexp.PITime_Baseline,1),std(output_OLexp.PITime_Test,1)];
XTickLabel = ["Self-control","Experiment"];
plotpairbar(y11,y12,y1_std,XTickLabel,"Positional Index")

p.time(1) = significanceTest(output_OLcontrol.PITime_Baseline,output_OLcontrol.PITime_Test,1);
p.time(2) = significanceTest(output_OLexp.PITime_Baseline,output_OLexp.PITime_Test,4);
legend('Before training','After training');

% plot the bar chart of PITurn
y21=[mean(output_OLcontrol.PITurn_Baseline),mean(output_OLexp.PITurn_Baseline)];
y22=[mean(output_OLcontrol.PITurn_Test),mean(output_OLexp.PITurn_Test)];

y2_std=[std(output_OLcontrol.PITurn_Baseline,1),std(output_OLcontrol.PITurn_Test,1),...
      std(output_OLexp.PITurn_Baseline,1),std(output_OLexp.PITurn_Test,1)];


plotpairbar(y21,y22,y2_std,XTickLabel,"Turning Index");

p.turn(1) = significanceTest(output_OLcontrol.PITurn_Baseline,output_OLcontrol.PITurn_Test,1);
p.turn(2) = significanceTest(output_OLexp.PITurn_Baseline,output_OLexp.PITurn_Test,4);
legend('Before training','After training');
end
