function p = significanceTest(preTrain,postTrain,x1,x2,y)

        [~,p] = ttest(preTrain,postTrain);
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
%sigSyms = ["n.s.",... % P > 0.05
 %           "*",...   % P < 0.05
 %           "**",...  % P < 0.01
 %           "***",... % P < 0.001
 %           "****"];  % P < 0.0001 % occassionally use
