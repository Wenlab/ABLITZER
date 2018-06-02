% Evaluate data quality based on bad points percentage
function evaluateDataQuality(obj)
    % Constant Parameters
    distThre = 100;
    
    head = cat(1,obj.Frames.Head);
    headDiff = diff(head);
    headChange = sqrt(headDiff(:,1).^2 + headDiff(:,2).^2);
    % the second term measures frames fish unmoved for at least 1
    % seconds
    numBadPts = length(find(headChange > distThre))...
        + length(find(smooth(headChange,10) == 0));
    
    obj.Res.DataQuality = 1 - numBadPts/length(head);


end