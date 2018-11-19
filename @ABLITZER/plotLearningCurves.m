% plot learning curves of learners, non-learners, and the all
function plotLearningCurves(obj, ... % ABLITZER object
    metric, ... % metric type (positional/turning)
    whichClass) % which classes to plot (0. all fish 1. learners only; 2. with non-learners)
    
fprintf('Please make sure fish performances have been rated.\n');


obj.classifyFish("ExpTask");
idxExp = obj.FishGroups(2).Data;
numFish = length(idxExp);
ifLearnedArr = zeros(numFish,1);
trMat = []; % the matrix to store trials of all fish, rows count fish, cols count trials
if contains(metric,'positional','IgnoreCase',true)
    
    for i = 1:numFish
        idx = idxExp(i);
        fish = obj.FishStack(idx);
        PI = fish.Res.PItime; 
        trials = transpose(cat(1,PI.Trial));
        trMat = cat(1,trMat,trials);
        ifLearnedArr(i) = fish.Res.IfLearned;
    end
     
    yLab = "Positional Index";
elseif contains(metric,'turning','IgnoreCase',true)
    for i = 1:numFish
        idx = idxExp(i);
        fish = obj.FishStack(idx);
        PI = fish.Res.PIturn; 
        trials = transpose(cat(1,PI.Trial));
        trMat = cat(1,trMat,trials);
        ifLearnedArr(i) = fish.Res.IfLearned;
    end
    yLab = "Turning Index";
elseif contains(metric,'shock','IgnoreCase',true)
    error('Sorry, this metric currently is not supported.\n');
else
    fprintf("Unrecognized metric");
    return;
end

if ~isempty(find(isnan(ifLearnedArr), 1))
    fprintf('Please judge whether fish learned before using this function\n');
    return;
end
idxL = find(ifLearnedArr); % indices of learners
idxNL = find(~ifLearnedArr);% indices of non-learners
numL = length(idxL);
numNL = length(idxNL);
Lers = trMat(idxL,:);
NLers = trMat(idxNL,:);
figure;
hold on;
t = (1:size(trMat,2))*2; % min
t(end-9:end) = t(end-9:end) + 1; % shift the time due to the blackout
if whichClass == 0
    meanL = mean(Lers,1);
    semL = std(Lers,1,1)/sqrt(numL); % standard error of the mean
    meanNL = mean(NLers,1);
    semNL = std(NLers,1,1)/sqrt(numNL); % standard error of the mean
    meanAll = mean(trMat,1);
    semAll = std(trMat,1,1)/sqrt(numL+numNL);
    
%     plot(t,meanL,'black');   
%     plot(t,meanNL,'color',[0.5,0.5,0.5]);
%     plot(t,meanAll,'k--');
%     
    errorbar(t,meanL,semL,'color',[0,0,0]);
    errorbar(t,meanNL,semNL,'color',[0.5,0.5,0.5],'lineStyle','--');
    errorbar(t,meanAll,semAll,'color',[0.5,0.5,0.5],'lineStyle','-.');  
    
    legend('Learners','Non-learners','All');
elseif whichClass == 1
    meanL = mean(Lers,1);
    semL = std(Lers,1,1)/sqrt(length(numL)); % standard error of the mean
    
    errorbar(t,meanL,semL,'color',[0,0,0]);
    legend('Learners');
elseif whichClass == 2
    meanL = mean(Lers,1);
    semL = std(Lers,1,1)/sqrt(length(numL)); % standard error of the mean
    meanNL = mean(NLers,1);
    semNL = std(NLers,1,1)/sqrt(length(numNL)); % standard error of the mean
    
    errorbar(t,meanL,semL,'color',[0,0,0]);
    errorbar(t,meanNL,semNL,'color',[0.5,0.5,0.5],'lineStyle','--');
    legend('Learners','Non-learners');
else
    error('Please enter the number (0. all fish 1. learners only; 2. with non-learners)');
end
    
ylim([0,1]);
xlabel('Time (min)');
ylabel(yLab);



end