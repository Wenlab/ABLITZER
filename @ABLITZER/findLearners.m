% Abstract:
%   Find all learners (and non-learners) in obj.FishStack and return their
%   indices. The output is index matrix where the first column stands for 
%   the experiment group and the second column stands for the control group
%
% SYNTAX

% Find all learners in FishStack
function [idxL, idxNL] = findLearners(obj)
    obj.classifyFish("ExpType");
    idxCtrl = obj.FishGroups(1).Data;
    idxExp = obj.FishGroups(2).Data;
    
    labels = zeros(length(idxExp),1); % label array of learner or non-learner
    
    for i = 1:length(idxExp)
        fish = obj.FishStack(idxExp(i));
        if fish.sayIfLearned
            labels(i) = 1;
        else
            labels(i) = 0;
        end 
    end
    
    idxL = find(labels == 1);
    idxNL = find(labels == 0);
    
    idxL = cat(2,idxExp(idxL)',idxCtrl(idxL)');
    idxNL = cat(2,idxExp(idxNL)',idxCtrl(idxNL)');
    



end