function Results = calcPIsMLByAge(a)
t = 1;
p = 1;
for i = 1:length(a)
  for j = 1:length(a(i).FishStack)
   [~,num_trail,~,~] = sayExtTimeandIfLearned(a(i).FishStack(j));
     if num_trail~=0
       MemoryL(t) = num_trail*60;
       Age(t)= a(i).FishStack(j).Age;  %Age(t)= str2num(a(i).FishStack(j).Age);
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
         AgeTurn(p)= a(i).FishStack(j).Age;  %AgeTurn(p)= str2num(a(i).FishStack(j).Age);
         PITurn_D(p)=PIturnTest(p)-PIturnBaseline(p);
         p=p+1;
       end
     end
  end
end

Data(1).fish = Age;
Data(2).fish = PITime_D;
Data(3).fish = MemoryL;
Data(4).fish = AgeTurn;
Data(5).fish = PITurn_D;
Results = dividedifferentAge(Data);


end

function Results = dividedifferentAge(Data)
 for i = 7:10
idx1 = find(Data(1).fish==i);
Results((i-7)*3+1).fish = Data(2).fish(idx1);
Results((i-7)*3+2).fish = Data(3).fish(idx1);
idx2 = find(Data(4).fish==i);
Results((i-7)*3+3).fish = Data(5).fish(idx2);
end
end
