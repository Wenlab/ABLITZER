function [p,Ls,nLs,All] = plot_bar_Iflearned(Ls,nLs)
%get [Ls,nLs] by function divideByIflearned(a);

alls.FishStack = cat(2,Ls.FishStack,nLs.FishStack);
All = output_task(alls,"OLexp");
Ls = output_task(Ls,"OLexp");
nLs = output_task(nLs,"OLexp");

PIs.Ls=[Ls.PITime_Baseline;Ls.PITime_Test;Ls.PITurn_Baseline;Ls.PITurn_Test];
PIs.nLs=[nLs.PITime_Baseline;nLs.PITime_Test;nLs.PITurn_Baseline;nLs.PITurn_Test];
PIs.All=[All.PITime_Baseline;All.PITime_Test;All.PITurn_Baseline;All.PITurn_Test];

[Mean,Sem] = calcMeanSem(PIs);

XTickLabel = ["Learners","non-Learners","All"];
plotpairbar(Mean(1,:),Mean(2,:),Sem(1:6),XTickLabel,"Positional Index");


p.time(1) = significanceTest(PIs.Ls(1,:),PIs.Ls(2,:),1);
p.time(2) = significanceTest(PIs.nLs(1,:),PIs.nLs(2,:),4);
p.time(3) = significanceTest(PIs.All(1,:),PIs.All(2,:),7);

legend('Before training','After training');

plotpairbar(Mean(3,:),Mean(4,:),Sem(7:12),XTickLabel,"Turning Index");
p.turn(1) = significanceTest(PIs.Ls(3,:),PIs.Ls(4,:),1);
p.turn(2) = significanceTest(PIs.nLs(3,:),PIs.nLs(4,:),4);
p.turn(3) = significanceTest(PIs.All(3,:),PIs.All(4,:),7);

legend('Before training','After training');

end



function [Mean2,Sem] = calcMeanSem(PIs)
Mean = [mean(PIs.Ls,2);mean(PIs.nLs,2);mean(PIs.All,2)];
Mean2 = [Mean(1),Mean(5),Mean(9);Mean(2),Mean(6),Mean(10);...        %%PITimeBaselineMean;PITimeTestMean;
         Mean(3),Mean(7),Mean(11);Mean(4),Mean(8),Mean(12)];        %%PITurnBaselineMean;PITurnTestMean;
Sem(1:4) = calcSem(PIs.Ls);
Sem(5:8) = calcSem(PIs.nLs);
Sem(9:12) = calcSem(PIs.All);
end

function [Sem]=calcSem(Task)
for i=1:4
    Sem(i) = std((Task),1,2)/sqrt(length(Task(i,:)));
end
end
