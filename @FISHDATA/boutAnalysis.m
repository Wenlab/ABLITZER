% Based on the method from (Ingebretson and Masino, 2013)
% behavioral analysis based on bout events
function boutStat = boutAnalysis(obj)
boutStat = struct;

pixelSize = 30/300;
spThre = 0.5 * 1 ./ pixelSize; % 1.0 mm/s
durThre = 2; % frames, 200 ms
cumLen = calcAccumLen(obj);
sp = diff(cumLen);
BW = sp > spThre;

[L,numBout] = bwlabel(BW);

for i = 1:numBout
    idx = find(L == i);
    boutStat(i).start = idx(1); % frame
    boutStat(i).end = idx(end);
    boutStat(i).duration = length(idx);
    if i == 1
        boutStat(i).interval = nan;
    else
        boutStat(i).interval = boutStat(i).start - boutStat(i-1).end;
    end
    tempVec = obj.Frames(idx(1)).Head - obj.Frames(idx(end)).Head;
    boutStat(i).dist = norm(tempVec);
    
    
end

durArr = cat(1,boutStat.duration);
idxR = durArr <= durThre;
boutStat(idxR) = [];


end