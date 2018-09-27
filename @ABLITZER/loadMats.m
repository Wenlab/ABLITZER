% - loadMats(byKeywords): append fishStack to an existing ABLITZER obj
%   - ABLITZER method
%   - arg1: keywords to filter files
%   - arg2: append data / rewrite Data
%TODO: reduce redundant lines
function loadMats(obj, ... % ABLITZER object
    fileNames, ... % files to load, if absent, let the user to choose one file to load; if empty, load all files with filters;
    pathName,... % directory to process files, if empty, choose the dir by the UI
    keywords, ... % keywords in filenames to choose files to process; such as strainName, age, etc.
    loadMethod) % 'append' or 'rewrite' to the existing fishStack

%% Deal with different input cases (classified by the number of input arguments)
if nargin == 1 % append all FISHDATA objs to the existing FishStack;
    [fileName,pathName] = uigetfile('*.mat');
    fprintf('Reading file: %s\n',fileName);
    tempData = load([pathName,fileName]);
    dName = fieldnames(tempData);
    tempObj = getfield(tempData,dName{1,1});
    fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
    obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
elseif nargin == 2
    % and select the directory by the UI
    [~,pathName] = uigetfile('*.mat');
    if isempty(fileNames)
        fInfo = dir([pathName,'*.mat']);
        numFiles = length(fInfo);
        for i = 1:numFiles
            fprintf('Reading file: %s\n',fInfo(i).name);
            tempData = load([pathName,fInfo(i).name]);
            dName = fieldnames(tempData);
            tempObj = getfield(tempData,dName{1,1});
            fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
            obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
        end
    else
        numFiles = length(fileNames);
        for i = 1:numFiles
            fprintf('Reading file: %s\n',fileNames(i));
            fName = [pathName,fileNames(i)];
            tempData = load(pathName,fName);
            dName = fieldnames(tempData); % name of saved ABLITZER obj
            tempObj = getfield(tempData,dName{1,1});
            fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
            obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
        end
    end
elseif nargin == 3
    if isempty(pathName)
        [~,pathName] = uigetfile('*.mat');
    end
    
    if isempty(fileNames)
        fInfo = dir([pathName,'*.mat']);
        numFiles = length(fInfo);
        for i = 1:numFiles
            fprintf('Reading file: %s\n',fInfo(i).name);
            tempData = load([pathName,fInfo(i).name]);
            dName = fieldnames(tempData);
            tempObj = getfield(tempData,dName{1,1});
            fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
            obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
        end
    else
        numFiles = length(fileNames);
        for i = 1:numFiles
            fprintf('Reading file: %s\n',fileNames(i));
            fName = [pathName,fileNames(i)];
            tempData = load(pathName,fName);
            dName = fieldnames(tempData); % name of saved ABLITZER obj
            tempObj = getfield(tempData,dName{1,1});
            fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
            obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
        end
    end
elseif nargin == 4
    if isempty(pathName)
        [~,pathName] = uigetfile('*.mat');
    end
    
    if isempty(fileNames)
        fInfo = filterByKeywords(keywords, pathName);
        numFiles = length(fInfo);
        for i = 1:numFiles
            fprintf('Reading file: %s\n',fInfo(i).name);
            tempData = load([pathName,fInfo(i).name]);
            dName = fieldnames(tempData);
            tempObj = getfield(tempData,dName{1,1});
            fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
            obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
        end
        
    else
        numKeys = length(keywords);
        searchStr = pathName;
        for i=1:numKeys
            searchStr = cat(2,searchStr,'*',char(keywords(i)));
        end
        searchStr = cat(2,searchStr,'*.mat');
        idxMatch = contains(fileNames,searchStr);
        numFiles = length(idxMatch);
        for i = 1:numFiles
            if (idxMatch(i))
                fprintf('Reading file: %s\n',fileNames(i));
                fName = [pathName,fileNames(i)];
                tempData = load(pathName,fName);
                dName = fieldnames(tempData); % name of saved ABLITZER obj
                tempObj = getfield(tempData,dName{1,1});
                fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
                obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
            end
        end
        
    end
    
elseif nargin == 5
    if strcmpi(loadMethod,'append')
        %doing nothing
    elseif strcmpi(loadMethod,'rewrite')
        obj.FishStack = []; %erase all existing FISHDATA
    else
        error('Wrong loadMethod!\nPlease enter "append" or "write"');
    end
    
    if isempty(pathName)
        [~,pathName] = uigetfile('*.mat');
    end
    
    if isempty(fileNames)
        fInfo = filterByKeywords(keywords, pathName);
        numFiles = length(fInfo);
        for i = 1:numFiles
            fprintf('Reading file: %s\n',fInfo(i).name);
            tempData = load([pathName,fInfo(i).name]);
            dName = fieldnames(tempData);
            tempObj = getfield(tempData,dName{1,1});
            fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
            obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
        end
        
    else
        numKeys = length(keywords);
        searchStr = pathName;
        for i=1:numKeys
            searchStr = cat(2,searchStr,'*',char(keywords(i)));
        end
        searchStr = cat(2,searchStr,'*.mat');
        idxMatch = contains(fileNames,searchStr);
        numFiles = length(idxMatch);
        for i = 1:numFiles
            if (idxMatch(i))
                fprintf('Reading file: %s\n',fileNames(i));
                fName = [pathName,fileNames(i)];
                tempData = load(pathName,fName);
                dName = fieldnames(tempData); % name of saved ABLITZER obj
                tempObj = getfield(tempData,dName{1,1});
                fprintf('%d valid FISHDATA imported.n',length(tempObj.FishStack));
                obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
            end
        end
        
    end
    
end

end

% Filter all files in the same directory by keywords
function fInfo = filterByKeywords(keywords, pathName)
% process keywords
numKeys = length(keywords);
searchStr = pathName;
for i=1:numKeys
    searchStr = cat(2,searchStr,'*',char(keywords(i)));
end
searchStr = cat(2,searchStr,'*.mat');
fInfo = dir(searchStr);

end