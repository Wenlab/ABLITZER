function plotbarPIsMemoryLByAge(a)
  t = 1;
  p = 1;
  for i = 1:length(a)
    for j = 1:length(a(i).FishStack)
     [~,num_trail,~,~] = sayExtTimeandIfLearned(a(i).FishStack(j));
       if num_trail~=0
         MemoryL(t) = num_trail*60;
         Age(t)= a(i).FishStack(j).Age;
         ExtFrame=MemoryL(t)*10;
         PItimeBaseline(t)= (mean(a(i).FishStack(j).Res.PItime(1).Scores+1))/2;
         PItimeTest(t)= (mean(a(i).FishStack(j).Res.PItime(4).Scores(1:ExtFrame)+1))/2;
         PITime_D(t)=PItimeTest(t)-PItimeBaseline(t);
         t=t+1;
         PIturnidx=find(a(i).FishStack(j).Res.PIturn(4).TurnTiming<18600+num_trail*600);
         J = isempty(PIturnidx);
         if J==0
           PIturnTest(p)=(mean(a(i).FishStack(j).Res.PIturn(4).Scores(length(PIturnidx))+1))/2;
          PIturnBaseline(p)= (mean(a(i).FishStack(j).Res.PIturn(1).Scores+1))/2;
          AgeTurn(p)= a(i).FishStack(j).Age;
      %   PIturnTest(t)= (mean(a(i).FishStack(j).Res.PIturn(4).Scores(1:ExtFrame)+1))/2;
        
         PITurn_D(p)=PIturnTest(p)-PIturnBaseline(p);
         p=p+1;
         end
       end
    end
  end


[PITi7,PITi8,PITi9,PITi10]=dividedifferentAge(Age,PITime_D);
[PITu7,PITu8,PITu9,PITu10]=dividedifferentAge(AgeTurn,PITurn_D);
[ML7,ML8,ML9,ML10]=dividedifferentAge(Age,MemoryL);
plotbar(PITi7,PITi8,PITi9,PITi10,"Positional Index Increment");
plotbar(PITu7,PITu8,PITu9,PITu10,"Turning Index Increment");
plotbar(ML7,ML8,ML9,ML10,"Memory Length");

end

function [Result7,Result8,Result9,Result10]=dividedifferentAge(Age,task)
  idx7=find(Age==7);
  Result7=task(idx7);
  idx8=find(Age==8);
  Result8=task(idx8);
  idx9=find(Age==9);
  Result9=task(idx9);
  idx10=find(Age==10);
  Result10=task(idx10);
 end

function plotbar(data1,data2,data3,data4,YLabel)
  y=[mean(data1,2),mean(data2,2),mean(data3,2),mean(data4,2)];
  err=[std(data1,1,2),std(data2,1,2),std(data3,1,2),std(data4,1,2)];

  x=[7 8 9 10];
  figure;
  bar(x,y,0.5,'FaceColor',[0.8,0.8,0.8]);

  hold on;
  errorbar(x,y,err,'.','Color',[0 0 0]);
   p=polyfit(x,y,1);
   y1 = polyval(p,x);
   plot(x,y1,'.','Color','red');
   plot(x,y1,'--','Color','red');
   ylabel(YLabel);
  xlabel("Age(dpf)");
end
