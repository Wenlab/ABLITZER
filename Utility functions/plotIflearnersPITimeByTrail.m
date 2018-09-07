function plotIflearnersPITimeByTrail(a)
[Ls,nLs] = divideByIflearned(a);
All.FishStack=[Ls.FishStack,nLs.FishStack];
[LsTrailMean,LsTrailSem]=calcMeanSemByTrail(Ls);
[nLsTrailMean,nLsTrailSem]=calcMeanSemByTrail(nLs);
[AllTrailMean,AllTrailSem]=calcMeanSemByTrail(All);

figure;
x=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24];
errorbar(x,LsTrailMean,LsTrailSem,'Color',[0.7 0.7 0.7],'Marker','^');
hold on;
errorbar(x,nLsTrailMean,nLsTrailSem,'Color',[0.7 0.7 0.7],'LineStyle','--','Marker','v');
errorbar(x,AllTrailMean,AllTrailSem,'Color',[0 0 0],'Marker','O');
legend('Learners','non-Learners','All');
ylabel("Positional Index");
xlabel("Trial Number");
end



function [TrailMean,TrailSem]=calcMeanSemByTrail(obj)
for i=1:length(obj.FishStack)
BaselineTrail(i,:)=measure_trail(obj.FishStack(i),1);
TrainingTrail(i,:)=measure_trail(obj.FishStack(i),2);
TestTrail(i,:)=measure_trail(obj.FishStack(i),4);
end
Trail=[BaselineTrail,TrainingTrail,TestTrail];
TrailMean=mean(Trail);
TrailSem=std(Trail,1,1);
end
