function [num_Ls,num_nLs]=plotIflearnersPITimeByTrail(Ls,nLs)
%get [Ls,nLs] by function divideByIflearned(a);
All.FishStack=[Ls.FishStack,nLs.FishStack];
[LsTrailMean,LsTrailSem]=calcMeanSemByTrail(Ls);
[nLsTrailMean,nLsTrailSem]=calcMeanSemByTrail(nLs);
[AllTrailMean,AllTrailSem]=calcMeanSemByTrail(All);
num_Ls=length(Ls.FishStack);
num_nLs=length(nLs.FishStack);
figure;
x=1:1:24;
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
obj.FishStack(i).Res.Trials=[BaselineTrail(i,:),TrainingTrail(i,:),TestTrail(i,:)];
end
Trail=[BaselineTrail,TrainingTrail,TestTrail];
TrailMean=mean(Trail);
TrailSem=std(Trail,1,1)/sqrt(length(Trail));
end
