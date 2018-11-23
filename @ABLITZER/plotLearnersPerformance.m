% Plot performance index (positional/turning) of learners,
% non-learners, and the all
function plotLearnersPerformance(obj,... %ABLITZAER object
    metric) % "positional" or "turning"
    
    [idxL, idxNL] = obj.findLearners;
    idxL = idxL(:,1);
    idxNL = idxNL(:,1);
    idxAll = [idxL;idxNL];
    
    output = obj.outputFeatures;
    
    if strcmpi(metric,"positional")
        PIs = nancat(2,cat(1,output(idxNL).PITime_Baseline),cat(1,output(idxNL).PITime_Test),...
            cat(1,output(idxL).PITime_Baseline),cat(1,output(idxL).PITime_Test),...
            cat(1,output(idxAll).PITime_Baseline),cat(1,output(idxAll).PITime_Test));
        yLab = "Positional Index";
    elseif strcmpi(metric,"turning")
        PIs = nancat(2,cat(1,output(idxNL).PITurn_Baseline),cat(1,output(idxNL).PITurn_Test),...
            cat(1,output(idxL).PITurn_Baseline),cat(1,output(idxL).PITurn_Test),...
            cat(1,output(idxAll).PITurn_Baseline),cat(1,output(idxAll).PITurn_Test));
        yLab = "Turning Index";
    else
        error('Please choose "positional" or "turning" as the metric');
    end
    
   xtLabels = ["Non-learners","Learners","All"]; 
   % mean and variance calculation
numCols = size(PIs,2);
M = nanmean(PIs,1);
err = nanstd(PIs,1,1)/sqrt(size(PIs,1));

M = transpose(reshape(M,[2,numCols/2]));
err = transpose(reshape(err,[2,numCols/2]));

% significance calculation
sigMat = reshape(1:numCols,2,numCols/2);
sigMat = cat(2,transpose(sigMat),zeros(numCols/2,1));
for i = 1:numCols/2
    [~,p] = ttest(PIs(:,2*i-1),PIs(:,2*i));  
    sigMat(i,3) = p;
end


    
barPlot(M,'errorbar',err,'significance',sigMat,'xticklabels',xtLabels,'ylabel',yLab);



end