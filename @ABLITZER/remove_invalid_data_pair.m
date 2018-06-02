% remove fish data whose data quality lower than threshold
% also when one of the expData or ctrlData removed, the other would
% be removed too
% TODO: put constrain to make sure the control data and exp data are
% absolutely from the same fish
function remove_invalid_data_pair(obj)

qualThre = 0.95;
obj.classifyFishByTags("ExpType");
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