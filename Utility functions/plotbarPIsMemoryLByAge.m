function plotbarPIsMemoryLByAge(Results)
YLabel = ["Positional Index Increment","Memory Length","Turning Index Increment"];

for i = 1:3
  y=[mean(Results(i).fish),mean(Results(3+i).fish),...
      mean(Results(6+i).fish),mean(Results(9+i).fish)];
  err=[std(Results(i).fish,1)/sqrt(length(Results(i).fish)),...
      std(Results(3+i).fish,1)/sqrt(length(Results(3+i).fish)),...
      std(Results(6+i).fish,1)/sqrt(length(Results(6+i).fish)),...
      std(Results(9+i).fish,1)/sqrt(length(Results(9+i).fish))];

  x=[7 8 9 10];
  figure;
  bar(x,y,0.5,'FaceColor',[0.8,0.8,0.8]);
  hold on;
  errorbar(x,y,err,'.','Color',[0 0 0]);
   p=polyfit(x,y,1);
   y1 = polyval(p,x);
   plot(x,y1,'o','Color','red');
   plot(x,y1,'--','Color','red');
   ylabel(YLabel(i));
   xlabel("Age(dpf)");
end
end
