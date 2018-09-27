% obj personal analysis to see whether obj
% learned the task and to measure performance
% from several perspectives
% idxPostTr: indices of post trials for test
% TODO: rewrite this function to fit the current trial definition
function TrRes = personalAnalysis(obj,idxPostTr)

TrRes = zeros(24,5);
TrRes(:,1) = obj.ratePerformanceByTrials('time',false);
TrRes(:,2) = obj.ratePerformanceByTrials('turn',false);
TrRes(:,3) = obj.ratePerformanceByTrials('maxCSstayTime',false);
TrRes(:,4) = obj.ratePerformanceByTrials('dist2centerline',false);
TrRes(:,5) = obj.ratePerformanceByTrials('crossMidline',false);

% Plot results
plotfigure(TrRes,idxPostTr);
end

function plotfigure(TrRes,idxPostTr)

colors = 0.8*ones(2,3);
labels = {'pre-train','post-train'};
for j = 1:2
    figure(1); % significance plot
    subplot(1,2,j);
    cla;
    preTrain = TrRes(1:5,j);
    postTrain = TrRes(idxPostTr,j);
    PIs = nancat(2,preTrain,postTrain);
    UnivarScatter(PIs,'Label',labels,'Whiskers','lines','PointStyle','.',...
        'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[1,1,1],'PointSize',20,...
        'SEMColor',colors/1.5,'StdColor',[1,1,1]);
    set(gca,'YGrid','on'); % add yGrid to help compare data
    ylim([0,1]);
    switch j
        case 1
            titleStr = "Non-CS Area Time Proportion";
        case 2
            titleStr = "Turning Performance Index";
        case 3
            titleStr = "Longest stay time in CS area";
        case 4
            titleStr = "Mean Distance to Centerline";
        case 5
            titleStr = "Number of crossing mid-line";
    end
    title(titleStr);
  
    significanceTest(preTrain,postTrain,1,2,0.2)
   
end




for j = 1:2
    % Progress plot
    figure(2);
    subplot(1,2,j);
    cla;
    hold on;
    plot(TrRes(:,j),'b');
    line([idxPostTr(1) - 0.5,idxPostTr(1) - 0.5],...
        [0,1],'Color','r');
    title(titleStr);

end


end
