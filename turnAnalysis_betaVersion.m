% turn analysis beta version

% for single fish
SMat = zeros(4,2); % the matrix to store number of escape turn (+1)
% and foolish turn (-1) for each exp phase

for i = 1:4
    if i == 3
        continue;
    end
    scores = fish.Res.PIturn(i).Scores;
    SMat(i,1) = length(find(scores == 1));
    SMat(i,2) = length(find(scores == -1));
end


% for fish exp group
numFish = length(expFish);
% the matrix of number of escape turn for each fish in every phase
posTurns = zeros(4,numFish); 
% the matrix of number of escape turn for each fish in every phase
negTurns = zeros(4,numFish);

for i = 1:numFish
    fish = expFish(i);
    for j = 1:4
        if (j == 3) % blackout phase
            continue;
        end
        scores = fish.Res.PIturn(j).Scores;
        posTurns(j,i) = length(find(scores == 1));
        negTurns(j,i) = length(find(scores == -1));
    end
end