% Measure whether fish learned or not 
function ifLearned = sayIfLearned(obj)
    % If fishdata is control data, return nan 
    if contains(obj.ExpType,'control','IgnoreCase',true)
        ifLearned = NaN;
        obj.Res.IfLearned = ifLearned;
        return;
    end
    
    PItimeThre = 0.05;
    if obj.Res.PItime(4).PIfish - obj.Res.PItime(1).PIfish ...
            < PItimeThre
        ifLearned = false;
        obj.Res.IfLearned = ifLearned;
        return;
    end
    
    PIturnThre = 0.05;
    if obj.Res.PIturn(4).PIfish - obj.Res.PIturn(1).PIfish ...
            < PIturnThre
        ifLearned = false;
        obj.Res.IfLearned = ifLearned;
        return;
    end
    
    ifLearned = NaN;
    obj.Res.IfLearned = ifLearned;
        
end