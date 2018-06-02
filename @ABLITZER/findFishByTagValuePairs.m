
% Find desired fish by providing tag-value pairs
function indices = findFishByTagValuePairs(obj,varargin)
if nargin==0
    error('There\''s no input')
end
if mod(length(varargin),2)~=0
    error('The arguments should be in pairs,in which the first one is a string, as in ("ExpType","exp","Age",7)')
end

tags = string(varargin(1:2:end));
values = varargin(2:2:end);

%% Process tag-value pairs
obj.classifyFishByTags(tags);
str = values2str(values);
names = cat(1,obj.FishGroups.Name);
IDX = find(names == str);
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