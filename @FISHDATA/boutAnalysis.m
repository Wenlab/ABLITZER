% Based on the method from (Ingebretson and Masino, 2013)
% behavioral analysis based on bout events
function boutStat = boutAnalysis(obj)
boutStat = struct;

pixelSize = 40/obj.ConfinedRect(4);
spThre = 0.5 * 1 ./ pixelSize; % 1.0 mm/s
durThre =0.2; % seconds
cumLen = calcAccumLen(obj);
sp = diff(cumLen);
BW = sp > spThre;

[L,numBout] = bwlabel(BW);
if numBout == 0
    boutStat = [];
    return
end
for i = 1:numBout
    idx = find(L == i);
    boutStat(i).start = idx(1); % frame
    boutStat(i).end = idx(end);
    boutStat(i).duration = length(idx)/10; % seconds
    if i == 1
        boutStat(i).interval = nan;
    else
        boutStat(i).interval = (boutStat(i).start - boutStat(i-1).end)/10;
    end
    tempVec = obj.Frames(idx(1)).Head - obj.Frames(idx(end)).Head;
    boutStat(i).dist = norm(tempVec) * pixelSize;
    
    
end

durArr = cat(1,boutStat.duration);
idxR = durArr <= durThre;
boutStat(idxR) = [];


end