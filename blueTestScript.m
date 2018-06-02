% script to import data from yaml and do basic analysis to check there is
% light preference in this paradigm
aObj = ABLITZER;
aObj.yaml2matlab;
fish = aObj.FishStack(1);
yDivide = fish.yDivide;
expPhase = cat(1,fish.Frames.ExpPhase);
head = cat(1,fish.Frames.Head);
pIdx = cat(1,fish.Frames.PatternIdx);

% checheck whether there is light preference in training section
idx = find(expPhase == 1);
tempPattern = pIdx(idx);
tempHead = head(idx,2);
idxNaN = find(tempHead == -1);
scores = zeros(length(idx),1);

% when the fish is in CS area, give him a credit, otherwise no point
for i = 1:length(idx)
    if tempPattern(i) == 0 % CS on the top
        scores(i) = 2*(tempHead(i) < yDivide) - 1;
    elseif tempPattern(i) == 1 % CS on the bottom
        scores(i) = 2*(tempHead(i) > yDivide) - 1;
    elseif tempPattern(i) == 2 % blackout
        scores(i) = 0;
    end
end

scores(idxNaN) = 0; % exclude the impact of invalid points
fish.Res.PItime(2).Scores = scores;
fish.Res.PItime(2).PIfish = length(find(scores==1)) / length(find(scores~=0));