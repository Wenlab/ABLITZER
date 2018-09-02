% Calculate reaction time for each trial
% Here, a trial is defined as the duration between two pattern changes
function  reactionTime = calcReactTimeByTrials(obj)

expPhase = cat(1,obj.Frames.ExpPhase);
pIdx = cat(1,obj.Frames.PatternIdx);

% for baseline





end

% every pattern change counted as a trial
%
function TrMat = getTrIndices(obj)

% 1st col: index of begin, 2nd col: index of end, 3rd col: expPhase
TrMat = [];

expPhase = cat(1,obj.Frames.ExpPhase);
pIdx = cat(1,obj.Frames.PatternIdx);

% for baseline
idxPhase = find(expPhase == 0);
tempPIdx = pIdx(idxPhase);
idx = find(diff(tempPIdx));
idxBegin = [1;idx+1];
idxEnd = [idx;length(idxPhase)];
TrMat = cat(1,TrMat,cat(2,idxBegin,idxEnd, 0 * ones(size(idxBegin))));

% for training
idxPhase = find(expPhase == 1);
tempPIdx = pIdx(idxPhase);
idx = find(tempPIdx == 2);
IDX = find(diff(idx) > 1);
idxBegin = [1;idx(IDX)+1];
idxEnd = [idx(IDX+1)-1;length(idxPhase)];
TrMat = cat(1,TrMat,cat(2,idxBegin,idxEnd, 1 * ones(size(idxBegin))));


% for test
idxPhase = find(expPhase == 3);
tempPIdx = pIdx(idxPhase);
idx = find(diff(tempPIdx));
idxBegin = [1;idx+1];
idxEnd = [idx;length(idxPhase)];
TrMat = cat(1,TrMat,cat(2,idxBegin,idxEnd, 3 * ones(size(idxBegin))));





end
