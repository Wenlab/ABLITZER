% In training, when fish stays in the NCS area for a long time,
% It would update the pattern, it is called a trial
% based on this, we can measure the accuracy of fish performed by time or
% by turn in each trial to see how learning process developed in the fish

% Caution: check before using this function
function plotLearningCurve(obj,metric)

fprintf('This function is applied to operant-learning tasks only\n');

if contains(metric,'positional','IgnoreCase',true)
    PI = obj.Res.PItime;  
    yLab = "Positional Index";
elseif contains(metric,'turning','IgnoreCase',true)
    PI = obj.Res.PIturn;
    yLab = "Turning Index";
else
    fprintf("Unrecognized metric");
    return;
end

if isempty(PI(1).Trial) || isempty(PI(2).Trial) || isempty(PI(4).Trial)
    fprintf("Please rate fish performance before using this function\n");
    return;
end


trials = cat(1,PI.Trial);
t = (1:length(trials)) * 2; % mins
t(end-9:end) = t(end-9:end) + 1; % shift the time due to the blackout

figure;
plot(t,trials);
ylim([0,1]);
ylabel(yLab);
xlabel('Time (min)');
cStr = char(obj.ExpStartTime);
cStr(9) = '-';%replace "_" with "-"
titleStr = string(cStr) + '-' + string(obj.Age) + 'dpf-' + obj.Strain + '-'...
+ obj.CSpattern + '-' + obj.ExpTask;
title(titleStr);









end
