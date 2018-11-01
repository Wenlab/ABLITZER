function plotPairBar(y,Sem,XTickLabel,YLabel)
if length(y)==2
   x1=2;
   x2=4;
   x=[2 4];
   y1=y(1);
   y2=y(2);
elseif length(y)==4  
  x1=[1 4];
  x2=[2 5];
  x=[ 1 2 4 5];
  y1=[y(1),y(3)];
  y2=[y(2),y(4)];
else
  x1=[1 4 7];
  x2=[2 5 8];
  x=[1 2 4 5 7 8];
  y1=[y(1),y(3),y(5)];
  y2=[y(2),y(4),y(6)];
 end
  figure;
  bar(x1,y1,0.28,'FaceColor',[0.9,0.9,0.9]);
  hold on;
  bar(x2,y2,0.28,'FaceColor',[0,0,0]);
  
  e=errorbar(x,y,Sem,'.','Color',[0 0 0]);
  e.Color=[0.5 0.5 0.5];
  ylim([0,1]);
  ylabel(YLabel);
  if length(y1)==1
    set(gca,'XTick',3);
    set(gca,'XTickLabel',{XTickLabel(2)});  
  elseif length(y1)==2
    set(gca,'XTick',[1.5 4.5]);
    set(gca,'XTickLabel',{XTickLabel(1),XTickLabel(2)});
  else  
    set(gca,'XTick',[1.5 4.5 7.5]);
    set(gca,'XTickLabel',{XTickLabel(1),XTickLabel(2),XTickLabel(3)});
  end
  end
  

