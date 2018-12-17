% calculate the accumulated length of fish swimming
function cumLen = calcAccumLen(obj)
    heads = cat(1,obj.Frames.Head);
    ds = diff(heads,1,1);
    d = sqrt(ds(:,1).^2+ds(:,2).^2);
    cumLen = cumsum(d);



end