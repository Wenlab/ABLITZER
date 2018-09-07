function p = plot_bar_Iflearned(a)
for i=1:length(a)
     a(i).remove_invalid_data_pair;
     for j=1:length(a(i).FishStack)
       sayIfLearned(a(i).FishStack(j),"time",0);
    end
end
Ls=a;
nLs=a;
Ls = divideByIflearned(a,1);
nLs = divideByIflearned(a,0);

output_OLexp_All = output_task(a,"OLexp");
output_OLexp_Ls = output_task(Ls,"OLexp");
output_OLexp_nLs = output_task(nLs,"OLexp");

%aver = struct('IfLearned',[],'PITime_Baseline',[],'PITime_Test',[],'PITurn_Baseline',[],'PITurn_Test',[]);
%aver(1).IfLearned="Learners";
%aver(2).IfLearned="Non-learners";
%aver(3).IfLearned="All";


y11=[mean(output_OLexp_Ls.PITime_Baseline),mean(output_OLexp_nLs.PITime_Baseline),mean(output_OLexp_All.PITime_Baseline)];
y12=[mean(output_OLexp_Ls.PITime_Test),mean(output_OLexp_nLs.PITime_Test),mean(output_OLexp_All.PITime_Test)];

y1_std=[std(output_OLexp_Ls.PITime_Baseline),std(output_OLexp_Ls.PITime_Test),...
      std(output_OLexp_nLs.PITime_Baseline),std(output_OLexp_nLs.PITime_Test),...
      std(output_OLexp_All.PITime_Baseline),std(output_OLexp_All.PITime_Test)];

XTickLabel = ["Learners","non-Learners","All"];
plotpairbar(y11,y12,y1_std,XTickLabel,"Poisitional Index");

p.time(1) = significanceTest(output_OLexp_Ls.PITime_Baseline,output_OLexp_Ls.PITime_Test,1);
p.time(2) = significanceTest(output_OLexp_nLs.PITime_Baseline,output_OLexp_nLs.PITime_Test,4);
p.time(3) = significanceTest(output_OLexp_All.PITime_Baseline,output_OLexp_All.PITime_Test,7);
legend('Before training','After training');

y21=[mean(output_OLexp_Ls.PITurn_Baseline),mean(output_OLexp_nLs.PITurn_Baseline),mean(output_OLexp_All.PITime_Baseline)];
y22=[mean(output_OLexp_Ls.PITurn_Test),mean(output_OLexp_nLs.PITurn_Test),mean(output_OLexp_All.PITurn_Test)];

y2_std=[std(output_OLexp_Ls.PITurn_Baseline),std(output_OLexp_Ls.PITurn_Test),...
      std(output_OLexp_nLs.PITurn_Baseline),std(output_OLexp_nLs.PITurn_Test),...
      std(output_OLexp_All.PITurn_Baseline),std(output_OLexp_All.PITurn_Test)];

plotpairbar(y21,y22,y2_std,XTickLabel,"Turning Index");

p.turn(1) = significanceTest(output_OLexp_Ls.PITurn_Baseline,output_OLexp_Ls.PITurn_Test,1);
p.turn(2) = significanceTest(output_OLexp_nLs.PITurn_Baseline,output_OLexp_nLs.PITurn_Test,4);
p.turn(3) = significanceTest(output_OLexp_All.PITurn_Baseline,output_OLexp_All.PITurn_Test,7);
legend('Before training','After training');
end

function b=divideByIflearned(a,m)
   for j = 1:length(a)
        q=1;
    for t =1:length(a(j).FishStack) % number of fish in the fishStack
        if a(j).FishStack(t).Res.IfLearned ==m
           b.FishStack(q)= a(j).FishStack(t);
           q=q+1;
        end
    end
          disp(t);
   end
 end