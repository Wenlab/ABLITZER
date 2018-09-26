function p = significanceTest(preTrain,postTrain,x1,x2,y)

        [~,p] = ttest(preTrain,postTrain);
        line([x1,x2],[y,y],'Color',[0,0,0]);

        if p > 0.05 % n.s.
           text(x1+0.3,y+0.05,'n.s.','FontSize',14);
        elseif p < 0.0001 % "****"
           text(x1+0.1,y+0.05,'****','FontSize',20);
        elseif p < 0.001 % "***"
           text(x1+0.2,y+0.05,'***','FontSize',20);
        elseif p < 0.01 % "**"
           text(x1+0.3,y+0.05,'**','FontSize',20);
        elseif p < 0.05 % "*"
           text(x1+0.4,y+0.05,'*','FontSize',20);
        end
end
%sigSyms = ["n.s.",... % P > 0.05
 %           "*",...   % P < 0.05
 %           "**",...  % P < 0.01
 %           "***",... % P < 0.001
 %           "****"];  % P < 0.0001 % occassionally use
