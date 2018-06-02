% Calculate fish body length by measuring average length between fish tail
% and head
function bodyLength = calcFishLen(obj)
    head = cat(1,obj.Frames.Head);
    tail = cat(1,obj.Frames.Tail);
    T2H = head - tail;
    bodyLens = sqrt(T2H(:,1).^2+T2H(:,2).^2);
    bodyLength = mean(bodyLens);
    if strcmp(obj.Strain,"GCaMP") % since a portion of fish tail is invisible
        bodyLength = bodyLength * 2;
    end
    
    
    obj.Res.BodyLength = bodyLength;
end