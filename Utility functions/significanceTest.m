function p = significanceTest(preTrain,postTrain,m)

        [~,p] = ttest(preTrain,postTrain);
        line([m,m+1],[0.8,0.8],'Color',[0,0,0]);

        if p > 0.05 % n.s.
           text(m+0.3,0.83,'n.s.','FontSize',14);
        elseif p < 0.0001 % "****"
           text(m+0.1,0.81,'****','FontSize',20);
        elseif p < 0.001 % "***"
           text(m+0.2,0.81,'***','FontSize',20);
        elseif p < 0.01 % "**"
           text(m+0.3,0.81,'**','FontSize',20);
        elseif p < 0.05 % "*"
           text(m+0.4,0.81,'*','FontSize',20);
        end
end
%sigSyms = ["n.s.",... % P > 0.05
 %           "*",...   % P < 0.05
 %           "**",...  % P < 0.01
 %           "***",... % P < 0.001
 %           "****"];  % P < 0.0001 % occassionally use
