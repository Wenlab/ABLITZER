% memory quantification test script

% plot distance to center line for single fish
% negative if fish in CS area, positive if fish in non-CS area
frameRate = fish.FrameRate;
height = fish.ConfinedRect(4);
yDiv = fish.yDivide;
pIdx = cat(1,fish.Frames.PatternIdx);
expPhase = cat(1,fish.Frames.ExpPhase);
heads = cat(1,fish.Frames.Head);
numFrames = length(pIdx);
y2CL = zeros(numFrames,1); % distance (in y) to center line
for i=1:numFrames
    if pIdx(i) == 0
        y2CL(i) = heads(i,2) - yDiv;
    elseif pIdx(i) == 1
        y2CL(i) = yDiv - heads(i,2);
    end
    
end
idx = find(expPhase == 3); 
tempY2CL = y2CL(idx);
fishLen = fish.Res.BodyLength;
distThre = -1.5*fishLen;
labelArr = tempY2CL < distThre;
CStimeThre = 5;
fThre = CStimeThre * frameRate;
extFrame = count_consecutive_frames(labelArr, fThre);


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


end