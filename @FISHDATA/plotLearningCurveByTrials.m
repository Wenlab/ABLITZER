% In training, when fish stays in the NCS area for a long time,
% It would update the pattern, it is called a trial
% based on this, we can measure the accuracy of fish performed by time or
% by turn in each trial to see how learning process developed in the fish

% Caution: check before using this function
function resMat = plotLearningCurveByTrials(obj,metric)

scores = obj.Res.PItime(2).Scores;
idx = find(scores == 0);
idxDiff = diff(idx);
IDX = find(idxDiff > 1);
trIdx = idx(IDX+1);
trIdx = [0;trIdx;length(scores)];
numTrials = length(IDX) + 1;
resMat = zeros(numTrials,1);
if contains(metric,'time','IgnoreCase',true)
    for i=1:numTrials
        idxBegin = trIdx(i);
        idxEnd = trIdx(i+1);
        idxTemp = (idxBegin+1):idxEnd;
        tempRes = sum(scores(idxTemp))/length(idxTemp);
        resMat(i) = (tempRes + 1) / 2;
    end
elseif contains(metric,'turn','IgnoreCase',true)
    scores = obj.Res.PIturn(2).Scores;
    idx = find(scores);
    scores = scores(idx);
    turnTiming = obj.Res.PIturn(2).TurnTiming(idx);

    for i=1:numTrials
        idxBegin = trIdx(i);
        idxEnd = trIdx(i+1);
        idxTemp = find((turnTiming > idxBegin)&(turnTiming <= idxEnd));
        if isempty(idxTemp)
            tempRes = 0;
        else
            tempRes = sum(scores(idxTemp))/length(idxTemp);
        end
        resMat(i) = (tempRes + 1) / 2;
    end


end


figure;
plot(resMat);




end
