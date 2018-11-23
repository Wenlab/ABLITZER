%   Copyright 2018 Wenbin Yang <bysin7@gmail.com>
%   This file is part of A-BLITZ-ER[1] (Analyzer of Behavioral Learning
%   In The ZEbrafish Result.) i.e. the analyzer of BLITZ[2].
%
%   BLITZ (Behavioral Learning In The Zebrafish) is a software that
%   allows researchers to train larval zebrafish to associate
%   visual pattern with electric shock in a fully automated way, which
%   is adapted from MindControl.[3]
%   [1]: https://github.com/Wenlab/ABLITZER
%   [2]: https://github.com/Wenlab/BLITZ
%   [3]: https://github.com/samuellab/mindcontrol


%   Current Version: 1.1
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Modified on: Nov. 2, 2018

%custom bar plot with several options:
%1. grouped/not grouped
%2. w/o errorbar
%3. w/o supplied with comparison-indices pairs and p-values
%4. w/o regression, method?
%5. xticklabels
%6. ylabel
% plot bar graph with error and regression
function h = barPlot(y,... % bins height
    varargin) % serves for key-value pairs

% bar face color auto grayscale from 1 to 0
% errorbar color: black
if nargin==0
    error('There\''s no input')
end
if mod(length(varargin),2)~=0
    error('The arguments should be in pairs,in which the first one is a string, as in ("ExpType","exp","Age",7)')
end

keys = string(varargin(1:2:end));
values = varargin(2:2:end);

%% Process key-value pairs

% errors
idx = find(keys == "errorbar");
if ~isempty(idx)
err = values{idx};
end

% sigStars
idx = find(keys == "significance");
if ~isempty(idx)
sigMat = values{idx}; % 1st and 2nd cols are cols compared and 3rd col is p-values
end

% regression
idx = find(keys == "regression");
if ~isempty(idx)
regMethod = values{idx};
end

% xticklabels
idx = find(keys == "xticklabels");
if ~isempty(idx)
xtLabs = values{idx};
end

% ylabel
idx = find(keys == "ylabel");
if ~isempty(idx)
yLab = values{idx};
end



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
    h.CData = (white+black)/2; % gray
    xPos = h.XData;
    if exist('err') % plot errorbar
        errorbar(xPos,y,err,'k.','color',errorBarClr);
    end
    
    if exist('sigMat') % sigStar plot
        for i = 1:size(sigMat,1) % draw one line for each row
            drawSigStar(xPos(sigMat(i,1)),xPos(sigMat(i,2)),max(y(:))+0.05,sigMat(i,3));
        end
    end
    
    if exist('regMethod') %TODO: finish this snippet
        regMethod = 'linear'; % currently, we only use the linear regression
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
    
    if exist('xtLabs') % add xticklabels
        xticks(1.5);
        xticklabels(xtLabs);
    end

    
else % grouped
    for ib = 1:numBobjs
        ratio = 1-1/(numBobjs-1)*(ib-1);
        barClr = white.*ratio;
        h(ib).CData = barClr;
        %XData property is the tick labels/group centers; XOffset is the offset
        %of each distinct group
        xData = h(ib).XData+h(ib).XOffset;
        xPos = cat(1,xPos,xData);
        if exist('err') % plot errorbar
            errorbar(xData,y(:,ib),err(:,ib),'k.','color',errorBarClr);
        end
        
    end
    
    if exist('sigMat') % sigStar plot
        for i = 1:size(sigMat,1) % draw one line for each row
            drawSigStar(xPos(sigMat(i,1)),xPos(sigMat(i,2)),max(y(:))+0.05,sigMat(i,3));
        end
    end
    
    if exist('regMethod') %TODO: finish this snippet
        regMethod = 'linear'; % currently, we only use the linear regression
    end
    
    if exist('xtLabs') % add xticklabels
        xticks(1:length(xtLabs));
        xticklabels(xtLabs);
    end
end


if exist('yLab') % add ylabel
    ylabel(yLab);
end

ylim([0,1]);
hold off;



end

% draw significance between two columns
function drawSigStar(x1,...% x-psotion of column 1
    x2,...% x-position of column 2
    y,... % height of the connected line
    p) % p-value
%sigSyms = ["n.s.",... % P > 0.05
 %           "*",...   % P < 0.05
 %           "**",...  % P < 0.01
 %           "***",... % P < 0.001
 %           "****"];  % P < 0.0001 % occassionally use
 line([x1,x2],[y,y],'Color',[0,0,0]);
 x = (x1+x2)/2;
 if p > 0.05 % n.s.
     str = sprintf('n.s. p=%6.4f\n',p);
 elseif p < 0.0001 % "****"
     str = sprintf('**** p=%6.4f\n',p);
 elseif p < 0.001 % "***"
     str = sprintf('*** p=%6.4f\n',p);
 elseif p < 0.01 % "**"
     str = sprintf('** p=%6.4f\n',p);
 elseif p < 0.05 % "*"
     str = sprintf('* p=%6.4f\n',p);
 end
 
 text(x,y+0.05,str,'FontSize',14);


end



