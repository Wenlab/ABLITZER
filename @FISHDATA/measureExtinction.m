% Measure the memory of fish of the learned association
% As I know, there are at least 2 kinds of memory: retention and extinction
% 1. when the CS pattern continues to show on but without electric shock
% the fish may un-learn the association.
% 2. after the fish learned, put them in normal raising house for a while,
% then test whether they will show escaping responses to CS pattern.
% In this experiment, we measured the first kind of memory
<<<<<<< HEAD

% TODO: rewrite this function to find the extinction point
=======
>>>>>>> 850eab9a93378e9610381f511732d13c006d2b1f
function extTime = measureExtinction(obj,plotFlag)
    testInterval = 120; % seconds
    frameRate = obj.FrameRate;
    windowWidth = testInterval * frameRate;
    PIthre = obj.Res.PItime(1).PIfish;
    pMov = calc_moving_PI(obj,windowWidth);

    t = (1:length(pMov)) / frameRate;
    if plotFlag
    figure;
    plot(t,pMov);
    xlabel('Time (s)');
    ylabel('Non-CS area time proportion');
   end
    extFrame = find(pMov(windowWidth:end) <= PIthre,1);
    if isempty(extFrame)
        extFrame = length(pMov);
    else
        extFrame = extFrame + windowWidth;
    end
    extTime = extFrame / frameRate;
    obj.Res.ExtinctTime = extTime;
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
