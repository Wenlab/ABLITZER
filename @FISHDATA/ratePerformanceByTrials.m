% Rate performance by trials, every 2 mins is counted as a trial
% TODO: decouple metrics from TrRes
function  TrRes = ratePerformanceByTrials(obj,metric,plotFlag)

% Metric input inspection
if strcmpi(metric,"time") % TODO: replace magic number
    idxMetric = 1;
    titleStr = "Non-CS Area Time Proportion";

elseif strcmpi(metric,"turn")
    idxMetric = 2;
    titleStr = "Turning Performance Index";

elseif strcmpi(metric,"maxCSstayTime")
    idxMetric = 3;
    titleStr = "Longest stay time in CS area";
elseif strcmpi(metric,"dist2centerline")
    idxMetric = 4;
    titleStr = "Mean Distance to Centerline";

elseif strcmpi(metric,"crossMidline")
    idxMetric = 5;
    titleStr = "Number of crossing mid-line";
else
    fprintf('Unrecognized metric, please choose one metric from the following:\n');
    fprintf('"time", "turn", "maxCSstayTime", "dist2centerline","crossMidline"');
    return;
end


% Parameters
interval = 120; %seconds % every 2 mins counted as a trial
fr = obj.FrameRate;
yDiv = obj.yDivide;
idx1 = 1:interval*fr:30*60*fr;
idx2 = 31*60*fr:interval*fr:49*60*fr;
idxBegin = [idx1,idx2(1:end-1)];
idxEnd = [idx1(2:end),30*60*fr,idx2(2:end-1),length(obj.Frames)];
phases = [zeros(1,5),ones(1,10),3*ones(1,9)];
TrMat = cat(2,idxBegin',idxEnd',phases');
numTrials = size(TrMat,1);
TrRes = zeros(numTrials,1);

switch idxMetric % calculate performance index for different metrics
    case 1 % non-CS area time proportion
        obj.calcPItime();
        scores = cat(1,obj.Res.PItime(1).Scores,obj.Res.PItime(2).Scores,...
            zeros(601,1),obj.Res.PItime(4).Scores); % TODO replace magic number
    o78    for i = 1:numTrials
            idxBegin = TrMat(i,1);
            idxEnd = TrMat(i,2);
            tempScores = scores(idxBegin:idxEnd);
            timeRes = length(find(tempScores==1)) / length(find(tempScores)); % excluded invalid scores '0'
            TrRes(i) = timeRes;
        end
    case 2 % escaping turning events
        obj.calcPIturn();
        turnScores = cat(1,obj.Res.PIturn.Scores);
        turnTiming = cat(1,obj.Res.PIturn.TurnTiming);
        idx = find(turnScores);
        turnScores = turnScores(idx);
        turnTiming = turnTiming(idx);
        numTurns = zeros(numTrials,1);
        for i = 1:numTrials
            idxBegin = TrMat(i,1);
            idxEnd = TrMat(i,2);
            idxTurn = find((turnTiming > idxBegin)&(turnTiming <= idxEnd));
            if isempty(idxTurn)
                turnRes = 0;
            else
                tempTurns = turnScores(idxTurn);
                numTurns(i) = length(tempTurns);
                turnRes = length(find(tempTurns==1))/numTurns(i);
            end
            TrRes(i) = turnRes;
        end
    case 3
        scores = cat(1,obj.Res.PItime(1).Scores,obj.Res.PItime(2).Scores,...
            zeros(601,1),obj.Res.PItime(4).Scores); % TODO replace magic number
        for i = 1:numTrials
            idxBegin = TrMat(i,1);
            idxEnd = TrMat(i,2);
            s = scores(idxBegin:idxEnd);
            idx = find(s ~= -1);
            s(idx) = 0;
            if s == 0
                TrRes(i) = 0;
            else
                m = regionprops(logical(s),'Area');
                areas = cat(1,m.Area);
                TrRes(i) = max(areas);
            end
        end


    case 4
        for i = 1:numTrials
            idxBegin = TrMat(i,1);
            idxEnd = TrMat(i,2);
            trIndices = idxBegin:idxEnd;
            pIdx = cat(1,obj.Frames(trIndices).PatternIdx);
            heads = cat(1,obj.Frames(trIndices).Head);

            pSign = pIdx * 2 - 1;
            y2CL = pSign .* (yDiv - heads(:,2));
            TrRes(i) = mean(y2CL);
        end
    case 5
        heads = cat(1,obj.Frames.Head);
        y = heads(:,2);
        L = y > yDiv;
        idx = find(diff(L));
        for i = 1:numTrials
            idxBegin = TrMat(i,1);
            idxEnd = TrMat(i,2);
            TrRes(i) = length(find((idx >= idxBegin) &...
                (idx <= idxEnd)));


        end
end

obj.Res.Trials(idxMetric).Data = TrRes;

idxB = 1:5; % baseline trials
idxT = 6:15; % training trials
idxP = 16:24; % probing trials

% if idxMetric == 1
%     obj.Res.PItime(1).PIfish = mean(TrRes(idxB));
%     obj.Res.PItime(2).PIfish = mean(TrRes(idxT));
%     obj.Res.PItime(4).PIfish = mean(TrRes(idxP));
% elseif idxMetric == 2
%     obj.Res.PIturn(1).PIfish = sum(TrRes(idxB).*numTurns(idxB)) / sum(numTurns(idxB));
%     obj.Res.PIturn(2).PIfish = sum(TrRes(idxT).*numTurns(idxT)) / sum(numTurns(idxT));
%     obj.Res.PIturn(4).PIfish = sum(TrRes(idxP).*numTurns(idxP)) / sum(numTurns(idxP));
% end


if plotFlag
    % Plot the results
    colors = 0.8*ones(2,3);
    labels = {'pre-train','post-train'};
    figure(1);

    preTrain = TrRes(1:5);
    postTrain = TrRes(end-8:end);
    PIs = nancat(2,preTrain,postTrain);
    UnivarScatter(PIs,'Label',labels,'Whiskers','lines','PointStyle','.',...
        'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[1,1,1],'PointSize',20,...
        'SEMColor',colors/1.5,'StdColor',[1,1,1]);
    set(gca,'YGrid','on'); % add yGrid to help compare data
    title(titleStr);

    % significance test
    significanceTest(preTrain,postTrain);

    % plot learning progress
    figure(2);
    plot(TrRes);
    title(titleStr);
end









end


function p = significanceTest(preTrain,postTrain)
        [~,p] = ttest2(preTrain,postTrain);
        line([1,2],[0.2,0.2],'Color',[0,0,0]);
        textPos = [1.5,0.25];
        if p > 0.05 % n.s.
           text(textPos(1),textPos(2),'n.s.','FontSize',14);
        elseif p < 0.0001 % "****"
           text(textPos(1),textPos(2),'****','FontSize',20);
        elseif p < 0.001 % "***"
           text(textPos(1),textPos(2),'***','FontSize',20);
        elseif p < 0.01 % "**"
           text(textPos(1),textPos(2),'**','FontSize',20);
        elseif p < 0.05 % "*"
           text(textPos(1),textPos(2),'*','FontSize',20);
        end



end
