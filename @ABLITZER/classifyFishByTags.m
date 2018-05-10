% TODO: reconstruct the entire code
function classifyFishByTags(obj,tags)
	fishStack = obj.FishStack;
	% make full combinational groups
	% numTags should not exceed 3
	numTags = length(tags);
	allTags = fieldnames(fishStack(1));
    dataTags = cell(numTags,1);
    uniqTagsCell = cell(numTags,1);
    typesMat = zeros(numTags,1);
    numGroups = 1; % number of groups in struct
    for i = 1:numTags
        idxApplied = find(cellfun(@(x) strcmp(tags(i),x),allTags));
        dataTags{i,1} = cellStr2Char(get(fishStack,char(allTags(idxApplied))));
        uniqTagsCell{i,1} = unique(dataTags{i,1});
        typesMat(i) = length(uniqTagsCell{i,1});
        numGroups = numGroups * typesMat(i);
    end
    
    % Create groups in struct
    dividers = ones(numTags,1);
    indices = zeros(numTags,1);
    for n = 2:numTags
        dividers(n) = dividers(n-1) * typesMat(n-1);
    end
    %tags2match = cell(numTags,1);
    for i = 1:numGroups
        nameStr = '';
        matchedIdx = 1:length(fishStack); % to eliminate unmatched idx every turn.
        for n = 1:numTags
            indices(n) = mod(i/dividers(n),typesMat(n));
            if (indices(n) == 0)
                indices(n) = typesMat(n);
            end
            strInCell = uniqTagsCell{n,1}(indices(n));
            tags2match = strInCell{1,1};
            matchedIdx = cmpStrWithCell(dataTags{n,1},tags2match,matchedIdx);
            nameStr = cat(2,nameStr,strInCell{1,1},'_');
        end    
        nameStr(end) = []; % drop the last '_'
        obj.FishGroups(i).Name = nameStr;
        obj.FishGroups(i).Tag = tags;
        obj.FishGroups(i).Data = matchedIdx;        
    end
    

end

% compare str with every element in the cell
% mIdx: matched indices
function mIdx = cmpStrWithCell(C,str,idx)
    mIdx = [];
    for i = 1:length(idx)
        nIdx = idx(i);
        if strcmp(C{nIdx,1},str)
            mIdx = [mIdx,nIdx];
        end
    end


end

% StringCell: in which all/some elements are string variables
function charCell = cellStr2Char(stringCell)
    numElem = length(stringCell);
    charCell = cell(numElem,1);
    for i=1:numElem
        charCell{i,1} = char(stringCell{i,1});    
    end

end