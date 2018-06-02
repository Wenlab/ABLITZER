% Measure the memory of fish of the learned association
% As I know, there are at least 2 kinds of memory: retention and extinction
% 1. when the CS pattern continues to show on but without electric shock
% the fish may un-learn the association.
% 2. after the fish learned, put them in normal raising house for a while,
% then test whether they will show escaping responses to CS pattern.
% In this experiment, we measured the first kind of memory
function extTime = measureMemory(obj)
    testInterval = 120; % seconds
    frameRate = obj.FrameRate;
    windowWidth = testInterval * frameRate;
    PIthre = obj.Res.PItime(1).PIfish;
    pMov = calc_moving_PI(obj,windowWidth);
    figure;
    t = (1:length(pMov)) / frameRate;
    plot(t,pMov);
    xlabel('Time (s)');
    ylabel('Non-CS area time proportion');
    extFrame = find(pMov(windowWidth:end) <= PIthre,1);
    if isempty(extFrame)
        extFrame = length(pMov);
    else
        extFrame = extFrame + windowWidth;
    end
    extTime = extFrame / frameRate;
end

% calculate moving PI over test with 120 s time window.
function pMov = calc_moving_PI(obj,windowWidth)
scores = obj.Res.PItime(4).Scores;
posLabel = scores == 1;
negLabel = scores == -1;
posSum = movmean(posLabel,windowWidth);
negSum = movmean(negLabel,windowWidth);
pMov = posSum./(posSum + negSum);
end


function extFrame = count_consecutive_frames(labelArr, fThre)
    counter = 0;
    for i=1:length(labelArr)
        if labelArr(i) % labelArr is a binary label vector
            counter = counter + 1;
        else
            counter = 0;
        end
        
        if counter >= fThre
            extFrame = i;
            return 
        end
    end
    extFrame = i;


end