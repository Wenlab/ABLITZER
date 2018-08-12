% plot bar graph with error
function [R2,p,h] = plotBarWithError(x,y,err)
errorBarClr = [0,0,0];
barFaceClr = [0.5,0.5,0.5];

h = figure;
hold on;
bar(x,y,'faceColor',barFaceClr);
errorbar(x,y,err,'color',errorBarClr);

mdl = fitlm(x,y);
cTable = mdl.Coefficients; % table of coefficients

yFit = cTable{1,1} + cTable{2,1} .* x;
plot(x,yFit,'--or');

xticks(x);
xlabel('Ages (dpf)');
%xlabel(mat2cell(x));

R2 = mdl.Rsquared.Ordinary;
p = cTable{2,length(x)};



end

