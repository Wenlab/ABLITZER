
% TODO: upgrade this function to findFishByTags.
% by harnessing the classification info from function classifyFishByTags.

function [indices, expType] = findFishByID(obj,fishID)
IDs = cat(1,obj.FishStack.ID);
indices = find(IDs == fishID);
expType = [];
for i=1:length(indices)
    idx = indices(i);
    expType = [expType,obj.FishStack(idx).ExpType];
end


end