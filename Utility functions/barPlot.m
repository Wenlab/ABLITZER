%custom bar plot with several options:
%1. grouped/not grouped
%2. w/o errorbar
%3. w/o supplied with comparison-indices pairs and p-values
%4. w/o regression, method?
%5. xticklabels
%6. ylabel
% plot bar graph with error and regression
function [R2,p,h] = barPlot(y,... % bins height
    err,... % errors for each bin, has to be in the same dimension with y
    varargin) % serves for key-value pairs

% bar face color auto grayscale from 1 to 0
% errorbar color: black
white = [1,1,1];
black = [0,0,0];
errorBarClr = black;

figure;
hold on;
h=bar(y,'FaceColor','flat');
pause(0.1); %pause allows the figure to be created
xPos = [];
numBobjs = numel(h);
if numBobjs == 1 % not grouped
    ax = h.Children;
    xPos = ax.Position;
else % grouped
    for ib = 1:numBobjs
        ratio = 1-1/(numBobjs-1)*(ib-1);
        barClr = white.*ratio;
        h(ib).CData = barClr;
        %XData property is the tick labels/group centers; XOffset is the offset
        %of each distinct group
        xData = h(ib).XData+h(ib).XOffset;
        xPos = cat(1,xPos,xData);
    end
end
    

% Judge if a grouped chart? x-positions will be different


% errorBarClr = [0,0,0];
% barFaceClr = [0.5,0.5,0.5];
% 
% h = figure;
% hold on;
% bar(x,y,'faceColor',barFaceClr);
% errorbar(x,y,err,'color',errorBarClr);
% 
% mdl = fitlm(x,y);
% cTable = mdl.Coefficients; % table of coefficients
% 
% yFit = cTable{1,1} + cTable{2,1} .* x;
% plot(x,yFit,'--or');
% 
% xticks(x);
% xlabel('Ages (dpf)');
% %xlabel(mat2cell(x));
% 
% R2 = mdl.Rsquared.Ordinary;
% p = cTable{2,length(x)};



end

