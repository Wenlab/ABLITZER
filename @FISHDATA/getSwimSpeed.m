% Calculate fish swimming speed
function  swimSpeed = getSwimSpeed(obj,phaseStr)

expPhase = cat(1,obj.Frames.ExpPhase);
if contains(phaseStr,'baseline','IgnoreCase',true)
    idx = find(expPhase == 0);
elseif contains(phaseStr,'training','IgnoreCase',true)
    idx = find(expPhase == 1);
elseif contains(phaseStr,'test','IgnoreCase',true)
    idx = find(expPhase == 2);
else
    fprintf('Invalid input.\n');
    fprintf('Please enter one of the following:\n baseline, training, test\n');
end

heads = cat(1,obj.Frames(idx).Head);
headChanges = diff(heads,1,1);
distance = sum(sqrt(headChanges(:,1).^2 + headChanges(:,2).^2));
interval = obj.Frames(idx(end)).TimeElapsed - obj.Frames(idx(1)).TimeElapsed;
swimSpeed = distance / interval; % pixel per second

end