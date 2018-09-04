function plotpairbar(y1,y2,y_std,XTickLabel,YLabel)
if length(y1)==3
  x1=[1 4 7];
  x2=[2 5 8];
  x=[1 2 4 5 7 8];
  y=[y1(1),y2(1),y1(2),y2(2),y1(3),y2(3)];
else
  x1=[1 4];
  x2=[2 5];
  x=[ 1 2 4 5];
  y=[y1(1),y2(1),y1(2),y2(2)];
end
  figure;
  bar(x1,y1,0.28,'FaceColor',[0.9,0.9,0.9]);
  hold on;
  bar(x2,y2,0.28,'FaceColor',[0,0,0]);
  
  e=errorbar(x,y,y_std,'.','Color',[0 0 0]);
  e.Color=[0.5 0.5 0.5];
  ylim([0,1]);
  ylabel(YLabel);
  if length(y1)==3
  set(gca,'XTick',[1.5 4.5 7.5]);
  set(gca,'XTickLabel',{XTickLabel(1),XTickLabel(2),XTickLabel(3)});
else
  set(gca,'XTick',[1.5 4.5]);
  set(gca,'XTickLabel',{XTickLabel(1),XTickLabel(2)});
  end
end
