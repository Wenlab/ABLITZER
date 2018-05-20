% statistically plot non-CS area proportion versus time
% Currently, it only plots PItime scores
function plotPIsInTest(obj)
    fishStack = obj.FishStack;
    numFish = length(fishStack);
    framesInTest = 10790;
    S = zeros(framesInTest,numFish);
    for i = 1:numFish
         scores = fishStack(i).Res.PItime(4).Scores;
         S(:,i) = scores(1:framesInTest);
    end
    % convert all -1 to 0 to preprate for following calculation
    idxN = find(S < 0);
    S(idxN) = 0;
    % convert it into non-CS area proportion
    cumS = cumsum(S,1);
    P = zeros(size(S));
    for r = 1:framesInTest
        P(r,:) = cumS(r,:) / r;
    end
    Pmean = mean(P,2);
    Psem = mean((P - Pmean).^2,2);
    
    % 3rd-party library: Shaded-Error Plot
    shadedErrorBar([],Pmean,Psem);
    ylim([0.0,1.0]);
    

end