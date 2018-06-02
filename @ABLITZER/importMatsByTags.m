% load mat files which matches tags provided in the same directory
function importMatsByTags(obj, tags, pathName)
    if nargin == 2
        [~,pathName] = uigetfile('*.mat');
    end
    fInfo = filterByTags(tags, pathName);
    numFiles = length(fInfo);
    for i = 1:numFiles
        fprintf('Reading file: %s\n',fInfo(i).name);
        tempData = load([pathName,fInfo(i).name]);
        fName = fieldnames(tempData);
        tempObj = getfield(tempData,fName{1,1});
        tempObj.remove_invalid_data_pair();
        fprintf('%d valid FISHDATA imported.\n',length(tempObj.FishStack));
        obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
    end
    
end

% Filter all files in the same directory by tags
function fInfo = filterByTags(tags, pathName)
    % process tags
    numTags = length(tags);
    searchStr = pathName;
    for i=1:numTags   
        searchStr = cat(2,searchStr,'*',char(tags(i)));
    end
    searchStr = cat(2,searchStr,'*.mat');
    fInfo = dir(searchStr);

end