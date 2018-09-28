%Abstract
% Find desired fish by providing key-value pairs

%SYNTAX:
%       1.  findFish(obj,key1,value1,...)

%TODO: Example code


function indices = findFish(obj, ... % ABLITZER object
  varargin) % key-value pairs, where keys are fields in FISHDATA
if nargin==0
    error('There\''s no input')
end
if mod(length(varargin),2)~=0
    error('The arguments should be in pairs,in which the first one is a string, as in ("ExpType","exp","Age",7)')
end

keys = string(varargin(1:2:end));
values = varargin(2:2:end);

%% Process key-value pairs
obj.classifyFishByKeys(keys);
str = values2str(values);
Values = cat(1,obj.FishGroups.Value);
IDX = find(Values == str);
indices = obj.FishGroups(IDX).Data;

end

function str = values2str(values)

    str = "";
    numValues = length(values);
    for i=1:length(values)
        str = str + string(values(i));
        if i ~= numValues
            str = str + "_";
        end
    end

end
