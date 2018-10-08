%Abstract:
% remove fish data whose data quality lower than threshold
% also when one of the expData or ctrlData removed, the other would
% be removed too
%
%SYNTAX:
%       1. obj.removeInvalidData(ifPaired), remove invalid data in pair or
%       individually; (In a day, ID is unique for each fish from the same
%       strain.)
%       2. obj.removeInvalidData(ifPaired,qualThre),
%  


function removeInvalidData(obj,... % ABLITZER object
    ifPaired,... % "paired" or "unpaired" to remove invalid data
    qualThre) % the threshold of DataQuality of fishData
% classify data in FishStack
% compare data qualities with the threshold, one fish fails, remove the entire row
% repeat the above steps
if nargin == 1
    fprintf('Please enter **paired** or **unpaired** as the 1st argument\n');
    fprintf('to remove fishData whose data quality lower than the threshold.');
    exit();
end


if strcmpi(ifPaired,'paired') % remove invalid fishData in pair
    badIndices = [];
    keys = ["ExpDate","Strain","ID"];
    if nargin == 2
        qualThre = 0.95;
    elseif nargin == 3
        % do nothing
    end
    obj.classifyFish(keys);
    numGroups = length(obj.FishGroups);
    for i = 1:numGroups % if one fails, eliminate the entire group
        fishGroup = obj.FishGroups(i).Data;
        for j = 1:length(fishGroup)
            fish = fishGroup(j);
            if fish.Res.DataQuality < qualThre
                badIndices = cat(1,badIndices,i);
                break;
            end
        end
    end 
    obj.FishStack(badIndices) = [];
    
    
elseif strcmpi(ifPaired,'unpaired') % remove invalid fishData individually
    badIndices = [];
    if nargin == 2
        qualThre = 0.95;     
    elseif nargin == 3     
        % do nothing
    end
    for i = 1:length(obj.FishStack)
        fish = obj.FishStack(i);
        if fish.DataQuality < qualThre
            badIndices = cat(1,badIndices,i);
        end
    end
    obj.FishStack(badIndices) = [];
    
else
    fprintf('Please enter **paired** or **unpaired** as the 1st argument\n');
    fprintf('to remove fishData whose data quality lower than the threshold.');
    exit();
end



end
