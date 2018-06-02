% load files by providing wanted fish strain, CS pattern 
% or other tags.

function obj = batchly_load_files_by_tags(tags)
%[~,pathName] = uigetfile('*.mat');
pathName = 'C:\Users\Young\Documents\Visual Modality may Affect Operant Learning Effect\ABLITZER_DATA\';
% process tags
numTags = length(tags);
searchStr = pathName;
for i=1:numTags   
    searchStr = cat(2,searchStr,'*',char(tags(i)));
end
searchStr = cat(2,searchStr,'*.mat');
fInfo = dir(searchStr);
numFiles = length(fInfo);

obj = ABLITZER;
dataCell = cell(numFiles,1);
for i=1:numFiles
    fprintf('Reading file: %s\n',fInfo(i).name);
    temp = load([pathName,fInfo(i).name]);
    fName = fieldnames(temp);   
    dataCell{i,1} = getfield(temp,fName{1,1});
    dataCell{i,1} = filter_invalid_data(dataCell{i,1});
    obj.FishStack = cat(1,obj.FishStack,dataCell{i,1}.FishStack);
end
N = length(obj.FishStack)/2;
%saveMatName = [pathName,char(tags(1)),'_',char(tags(2)),'_',char(tags(3)),...
%    '_validDataSet_N',num2str(N)];
%save(saveMatName,'obj');




end

% Eliminate fish whose dataQuality is lower than qualThre (0.95)
% once expData/ctrlData eliminated, both data eliminated
function obj = filter_invalid_data(obj)
    qualThre = 0.95;
    badIndices = []; % store bad index pairs
    obj.classifyFishByTags("ID");
    idxPairs = cat(1,obj.FishGroups.Data);
    for i=1:size(idxPairs,1)
        idx1 = idxPairs(i,1);
        idx2 = idxPairs(i,2);
        if (obj.FishStack(idx1).Res.DataQuality < qualThre) || ...
              (obj.FishStack(idx2).Res.DataQuality < qualThre)  
            badIndices = cat(2,badIndices,idxPairs(i,:));
        end
      
    end
    
    obj.FishStack(badIndices) = [];
    
    
    
end