% read data from correct pos yaml files
function posStruct = read_correct_pos_file(fileName)
if nargin == 0
    [f,p] = uigetfile('*.yaml');
    fileName = [p,f];
end
posStruct = struct('Head',[],'Center',[],'Tail',[],'HeadingAngle',[]);
fid = fopen(fileName);

MaxFrames = 30000; % the max number of frames
numFish = 2;
% read frames until the end
frames(MaxFrames,numFish) = FRAMEDATA;

idxFrame = 0;
idxFish = 1;

while (~feof(fid))
    [key, value] = read_a_line(fid);
    if (~isempty(key))
        switch key
            case 'Frames'
                idxFrame = idxFrame + 1;
                % show the progress
                if (mod(idxFrame,100)==0)
                    disp(idxFrame);
                end
            case 'FrameNum'
                for i = 1:numFish
                    frames(idxFrame,i).FrameNum = str2num(value);
                end
            case 'FishIdx'
                idxFish = str2num(value) + 1;
            case 'Head'
                frames(idxFrame,idxFish).Head = str2num(value);
            case 'Tail'
                frames(idxFrame,idxFish).Tail = str2num(value);
            case 'Center'
                frames(idxFrame,idxFish).Center = str2num(value);
            case 'HeadingAngle'
                frames(idxFrame,idxFish).HeadingAngle = str2num(value);
            otherwise
                disp(['Unrecognized keyword: ', key]);
        end
    end
end

frames(idxFrame:end,:) = []; % remove redundant frames
for i = 1:numFish
    posStruct(i).Head = cat(1,frames(:,i).Head);
    posStruct(i).Center = cat(1,frames(:,i).Center);
    posStruct(i).Tail = cat(1,frames(:,i).Tail);
    posStruct(i).HeadingAngle = cat(1,frames(:,i).HeadingAngle);
end

end

function [key, value] = read_a_line(fid)
% read a line in yaml and convert the value to struct
% if it is a key-value pair.
tline = fgets(fid);
newLine = remove_brackets(tline);
if (contains(newLine,":"))
    [key,value] = readKeyValuePair(newLine);
else
    key = [];
    value = [];
end

end

function newLine = remove_brackets(tline)
    startIdx = strfind(tline,"{");
    if isempty(startIdx)
        newLine = tline;
        return
    else
        endIdx = strfind(tline,"}");
        newLine = tline(startIdx+1:endIdx-1);
    end
    

end

function [fieldName,value] = readKeyValuePair(str)
    q=textscan(str,'%q','Delimiter',':');
    fieldName = q{1}{1};
    if (length(q{1}) >= 2)
        value = q{1}{2};
    else
        value = [];
    end
end
