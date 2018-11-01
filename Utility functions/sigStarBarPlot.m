% plot bar graph indicated with significance level between groups 
% compare groups 2*i+1 and 2i+2, i starts from 0;
function [x,h] = sigStarBarPlot(PIs)
numCols = size(PIs,2);
if mod(numCols,2)
    error("please enter a paired input");
end
M = mean(PIs,1);
err = std(PIs,1,1)/sqrt(size(PIs,1));

M = reshape(M,[numCols/2,2]);
err = reshape(err,[numCols/2,2]);
[x,h] = plotBarWithError(M,err);
% TODO: sigStar plot without known x
for ic = 1:2:numCols
    pairedSignificanceTest(PIs(:,ic),PIs(:,ic+1),...
    x(ceil(ic/2),1),x(ceil(ic/2),2),0.9);
    
end




end

function [x,h] = plotBarWithError(y,err)
errorBarClr = [0,0,0];
faceClr1 = [1,1,1];
faceClr2 = [0,0,0];
figure;
hold on;
h=bar(y,'FaceColor','flat');

h(1).CData = faceClr1;
h(2).CData = faceClr2;

x = [];
% the following snippet is adapted from 
% https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
pause(0.1); %pause allows the figure to be created
for ib = 1:numel(h)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = h(ib).XData+h(ib).XOffset;
    errorbar(xData,y(:,ib),err(:,ib),'k.','color',errorBarClr);
    x = cat(1,x,xData);
end
x = transpose(x);
ylim([0,1]);
hold off;



end

function p = pairedSignificanceTest(group1,group2,x1,x2,y)
        [~,p] = ttest(group1,group2);
        line([x1,x2],[y,y],'Color',[0,0,0]);
        x = (x1+x2)/2;
        if p > 0.05 % n.s.
           text(x,y+0.05,'n.s.','FontSize',14);
        elseif p < 0.0001 % "****"
           text(x,y+0.05,'****','FontSize',20);
        elseif p < 0.001 % "***"
           text(x,y+0.05,'***','FontSize',20);
        elseif p < 0.01 % "**"
           text(x,y+0.05,'**','FontSize',20);
        elseif p < 0.05 % "*"
           text(x,y+0.05,'*','FontSize',20);
        end
end
