% Measure the memory of fish of the learned association
% As I know, there are at least 2 kinds of memory: retention and extinction
% 1. when the CS pattern continues to show on but without electric shock
% the fish may un-learn the association.
% 2. after the fish learned, put them in normal raising house for a while,
% then test whether they will show escaping responses to CS pattern.
% In this experiment, we measured the first kind of memory
function extTime = measureMemory(obj,CStimeThre)
    fishLen = obj.Res.BodyLength;
    distThre = -1.5*fishLen;
    %CStimeThre = 5;
    frameRate = obj.FrameRate;
    height = obj.ConfinedRect(4);
    yStart = obj.ConfinedRect(2);
    yDiv = obj.yDivide;
    pIdx = cat(1,obj.Frames.PatternIdx);
    expPhase = cat(1,obj.Frames.ExpPhase);
    heads = cat(1,obj.Frames.Head);
    numFrames = length(pIdx);
    y2CL = zeros(numFrames,1);% distance (in y) to center line
    for i=1:numFrames
        if pIdx(i) == 0
            y2CL(i) = heads(i,2) - yDiv;
        elseif pIdx(i) == 1
            y2CL(i) = yDiv - heads(i,2);
        end

    end
    
    idx = find(expPhase == 3);
    tempY2CL = y2CL(idx);
    
    labelArr = tempY2CL < distThre; 
    fThre = CStimeThre * frameRate;
    extFrame = count_consecutive_frames(labelArr, fThre);
    extTime = extFrame / frameRate;
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