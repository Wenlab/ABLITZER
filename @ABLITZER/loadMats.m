%   Abstract:
%      Load FISHDATA objects from mat files to fishStack of an existing ABLITZER obj
%
%   SYNTAX:
%       1. obj.loadMats(); load a single file by selecting the file in the UI
%       2. obj.loadMats(fileNames);
%             2.1 load multiple files;
%             2.2 if fileNames is empty, load all mat files in the directory selected in the UI
%       3. obj.loadMats(fileNames,pathName);
%             3.1 load files specified by fileNames and pathName
%             3.2 if fileNames is empty, load all mat files in the directory of pathName
%             3.3 if pathName is empty, load files in fileNames in the directory selected in the UI
%       4. obj.loadMats(fileNames,pathName,keywords) load files matched the str pattern of keywords;
%           keywords have to be a string array, and order is required. It also inherits these empty options from case 3
%       5. obj.loadMats(fileNames,pathName,keywords,loadMethod)
%           if 'rewrite' is supplied for loadMethod, the existing fishStack would be erased.


function loadMats(obj, ... % ABLITZER object
    fileNames, ... % files to load, if absent, let the user to choose one file to load; if empty, load all files with filters;
    pathName,... % directory to process files, if empty, choose the dir by the UI
    keywords, ... % keywords in filenames to choose files to process; such as strainName, age, etc.
    loadMethod) % 'append' or 'rewrite' to the existing fishStack

postfix = '.mat';
%% Deal with different input cases (classified by the number of input arguments)
if nargin == 1
    [fileName,pathName] = uigetfile(['*',postfix]);
    %TODO: whether the output variable needed
    loadOneFile(obj,fileName,pathName);

elseif nargin == 2
    % and select the directory by the UI
    [~,pathName] = uigetfile(['*',postfix]);
    loadFiles(obj, fileNames, pathName, postfix);
elseif nargin == 3
    if isempty(pathName)
        [~,pathName] = uigetfile(['*',postfix]);
    end

    loadFiles(obj, fileNames, pathName, postfix);
elseif nargin == 4
    if isempty(pathName)
        [~,pathName] = uigetfile(['*',postfix]);
    end
    %TODO: check whether the function would work if keywords is empty
    loadFilesWithFilters(obj, fileNames, pathName, postfix, keywords);

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
    loadFilesWithFilters(obj, fileNames, pathName, postfix, keywords);

end

end

% load files without filters
function obj = loadFiles(obj, fileNames, pathName, postfix)
if isempty(fileNames)
    fInfo = dir([pathName,'*',postfix]);
    numFiles = length(fInfo);
    for i = 1:numFiles
        obj = loadOneFile(obj,fInfo(i).name,pathName);
    end
else
    numFiles = length(fileNames);
    for i = 1:numFiles
        obj = loadOneFile(obj,fileNames(i),pathName);
    end
end
end

% load files in a directory with filters
function obj = loadFilesWithFilters(obj, fileNames, pathName, postfix, keywords)
    if isempty(fileNames)
        fInfo = filterByKeywords(pathName, keywords, postfix);
        numFiles = length(fInfo);
        for i = 1:numFiles
            obj = loadOneFile(obj,fInfo(i).name,pathName);
        end

    else
        strPattern = getStrPattern(keywords,postfix);
        idxMatch = contains(fileNames,strPattern);
        numFiles = length(idxMatch);
        for i = 1:numFiles
            if (idxMatch(i))
                obj = loadOneFile(obj,fileNames(i),pathName);
            end
        end
    end
end

% load one file by the specific filename and pathname
function obj = loadOneFile(obj,fileName,pathName)
    fprintf('Reading file: %s\n',fileName);
    % load one file
    tempData = load([pathName,fileName]);
    dName = fieldnames(tempData);
    tempObj = getfield(tempData,dName{1,1});
    obj.FishStack = cat(1,obj.FishStack,tempObj.FishStack);
    fprintf('%d valid FISHDATA imported.\n',length(tempObj.FishStack));
end

function strPattern = getStrPattern(keywords,postfix)
% process keywords
numKeys = length(keywords);
strPattern = '';
for i=1:numKeys
    strPattern = cat(2,strPattern,'*',char(keywords(i)));
end
strPattern = cat(2,strPattern,'*',postfix);


end

% Filter all files in the same directory by keywords
function fInfo = filterByKeywords(pathName, keywords, postfix)
strPattern = getStrPattern(keywords,postfix);
strPattern = cat(2,pathName,strPattern);
fInfo = dir(strPattern);

end
