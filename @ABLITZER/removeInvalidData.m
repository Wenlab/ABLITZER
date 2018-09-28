%Abstract:
% remove fish data whose data quality lower than threshold
% also when one of the expData or ctrlData removed, the other would
% be removed too
%
%SYNTAX:
% TODO: how to extract expDate from existing data? I canget this info from fileNames,
%       however, we'd better write out this info in YAMLs
%       1. obj.removeInvalidData(), remove invalid data pairs, keys = ["ExpDate","Strain","ID"]
%          In a day, ID is unique for each fish from the same strain.
%       2. obj.removeInvalidData(keys),
%       3. obj.removeInvalidData(keys,qualThre)
% TODO: put constrain to make sure the control data and exp data are
% absolutely from the same fish
% TODO: rewrite the function as removeInvalidData to
% 1. remove a single fish
% 2. remove data pair (same fish in both self-control and experiment groups)
% 3. remove fish with specific features (remove data by keys?)

function removeInvalidData(obj)
% classify data in FishStack
% compare data qualities with the threshold, one fish fails, remove the entire row
% repeat the above steps

qualThre = 0.95;
obj.classifyFish("ExpType");
idxCtrl = obj.FishGroups(1).Data;
idxExp = obj.FishGroups(2).Data;
numPairs = length(idxExp);
badIndices = [];
for i=1:numPairs
     idx1 = idxCtrl(i);
     idx2 = idxExp(i);
     if (obj.FishStack(idx1).Res.DataQuality < qualThre) || ...
             (obj.FishStack(idx2).Res.DataQuality < qualThre)
         badIndices = cat(2,badIndices,idx1,idx2);
     end
end
obj.FishStack(badIndices) = [];

end
