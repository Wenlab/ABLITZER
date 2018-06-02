



% process exp-only data
% after imported data to ABLITZER obj



PImat = zeros(6,4);
for i=1:6
fish = obj.FishStack(i);
fish.ratePerformance;
PImat(i,1) = fish.Res.PItime(1).PIfish;
PImat(i,2) = fish.Res.PItime(2).PIfish;
PImat(i,3) = fish.Res.PIturn(1).PIfish;
PImat(i,4) = fish.Res.PIturn(2).PIfish;
end


% test new momory extinction measurement

numFish = length(idxExp);
extMat = zeros(numFish,2);
winWidth = 1200;
for i = 1:numFish
    idx = idxExp(i);
    fish = redObj.FishStack(idx);
    PIthre = fish.Res.PItime(1).PIfish;
    pMov = calc_moving_PI(fish);
    extFrame = find(pMov(winWidth:end) <= PIthre,1);
    if isempty(extFrame)
        extFrame = length(pMov);
    else
        extFrame = extFrame + winWidth;
    end
    extMat(i,1) = extFrame;
    extMat(i,2) = fish.Res.PItime(4).PIfish - fish.Res.PItime(1).PIfish;
end
Rsq = calc_Rsquare(extMat(:,1), extMat(:,2));


function incorporate_oldYamls(obj,dateStr)
    pathName = 'F:\FishExpData\operantLearning\';
    d = dir([pathName,'*',dateStr,'*G*.yaml']);
    bIdx = 0;
    for fIdx = 1:2:length(d)
        fprintf('Processing file pair: %d\n',(fIdx+1)/2);
        fileName1 =  d(fIdx).name;
        fileName2 = [pathName,d(fIdx+1).name];
        obj.oldYaml2matlab(-1,pathName,fileName1);
        posStruct = read_correct_pos_file(fileName2);
        overwrite_oldData(obj,posStruct,bIdx);
        bIdx = bIdx + 2;
    end
end

function overwrite_oldData(obj,posStruct,bIdx)
% replace head, tail, center, headingAngle with new data
    numFish = 2;
    for n = 1:numFish
        idxFish = n + bIdx;
        fish = obj.FishStack(idxFish);
        heads = posStruct(n).Head;
        tails = posStruct(n).Tail;
        centers = posStruct(n).Center;
        headingAngles = posStruct(n).HeadingAngle;
        for i = 1:min(length(fish.Frames),length(headingAngles)) % 1 frame shift
            fish.Frames(i).Head = heads(i,:);
            fish.Frames(i).Tail = tails(i,:);
            fish.Frames(i).Center = centers(i,:);
            fish.Frames(i).HeadingAngle = headingAngles(i);
        end     
    end

end

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

% plot shocks count as histograms in equal periods of training session
function shock_analysis_beta(obj)
obj.classifyFishByTags("ExpType");
fishStack = obj.FishStack;
expFish = fishStack(obj.FishGroups(2).Data);
numFish = length(expFish);

shockCell = cell(numFish,1);
for i=1:numFish
fish = expFish(i);
if (fish.Res.DataQuality < 0.95)
    continue;
end
shockCell{i,1} = fish.Res.PIshock;

end

% figure;
% hold on;
% for i=1:length(shockCell)
%     if (isempty(shockCell{i,1}))
%         continue;
%     end
%     shockTiming = shockCell{i,1}.ShockTiming;
%     scatter(shockTiming,i*ones(size(shockTiming)),'.');
% end

nBins = 2; % number of bins to count
nShocksArr = [];
shocksOn = [];
for i=1:length(shockCell)
    if (isempty(shockCell{i,1}))
        continue;
    end
    shockTiming = shockCell{i,1}.ShockTiming;
    N = histcounts(shockTiming,nBins);
    nShocksArr = cat(1,nShocksArr,N);
    shocksOn = cat(1,shocksOn,shockTiming);
end
%histogram(shocksOn,nBins);

figure;
set(gca,'YGrid','on'); % add yGrid to help compare data
labels = {'Beginning','Mid-term','Final'};
colors = 0.8*ones(nBins,3);
UnivarScatter(nShocksArr,'MarkerFaceColor',colors,...
'SEMColor',colors/1.5,'StdColor',colors/2);


end

function batchly_process_data_byTags(tags)
% Batchly process group of fish data to get performance index figures based
% on time and turn
tags = ["GCaMP","OL","redBlackCheckerboard"];
obj = batchly_load_files_by_tags(tags);
for i=1:length(obj.FishStack)
obj.FishStack(i).ratePerformance;
end
obj.classifyFishByTags("ExpType");
obj.plotPIsOfGroup(2,1,'time');
obj.plotPIsOfGroup(2,1,'turn');
obj.plotOntogenyByPI('time');
obj.plotOntogenyByPI('turn');
end

function shockPIMat = calc_weighted_shockPI(obj)
% calculate shock performance with distance to centerline as panelty
nBins = 5;
numFish = length(idxExp);
shockPIMat = zeros(numFish,nBins);
framesInTr = 12000;
for n = 1:numFish
    idx = idxExp(n);
    fish = obj.FishStack(idx);
    %fish.ratePerformance;
    PIshock = fish.Res.PIshock;
    frameRate = fish.FrameRate;
    scores = PIshock.Scores;
    shockTiming = PIshock.ShockTiming;

    edges = 0:ceil(framesInTr/nBins):framesInTr;
    if (edges(end) ~= framesInTr)
        edges = [edges,framesInTr];
    end
    sTime = zeros(nBins,1); % scores of each period in training  
    for i=1:nBins
        idxBegin = edges(i);
        idxEnd = edges(i+1);
        idx = find((shockTiming > idxBegin)&(shockTiming < idxEnd));
        if isempty(idx)
            sTime(i) = 1;
        else
            sTime(i) = sum(scores(idx));
        end  
    end
    shockPIMat(n,:) = sTime;
end
figure;
UnivarScatter(shockPIMat);
end

function output = get_output(obj)

% Get PItimes in all phases
output = struct('ExpTime',[],'ID',[],'Age',[],'Task',[],'DataQuality',[],...
    'PITime_Baseline',[],'PITime_Training',[],'PITime_Test',[],...
    'PITurn_Baseline',[],'PITurn_Training',[],'PITurn_Test',[],...
    'NumShock',[],'PIShock',[]);
obj.classifyFishByTags("ExpType");
idxExp = obj.FishGroups(2).Data;
for i = 1:length(idxExp)
    idx = idxExp(i);
    fish = obj.FishStack(idx);
    % Assign values to output
    output(i).ExpTime = fish.ExpStartTime;
    output(i).ID = fish.ID;
    output(i).Age = fish.Age;
    output(i).Task = fish.ExpTask;

    output(i).DataQuality = fish.Res.DataQuality;
    % PItime
    output(i).PITime_Baseline = fish.Res.PItime(1).PIfish;
    output(i).PITime_Training = fish.Res.PItime(2).PIfish;
    output(i).PITime_Test = fish.Res.PItime(4).PIfish;

    % PIturn
    output(i).PITurn_Baseline = fish.Res.PIturn(1).PIfish;
    output(i).PITurn_Training = fish.Res.PIturn(2).PIfish;
    output(i).PITurn_Test = fish.Res.PIturn(4).PIfish;

    % PIshock
    output(i).NumShock = fish.Res.PIshock.NumShocks;
    output(i).PIshock = fish.Res.PIshock.PIfish;     
      
end

end

% calculate moving PI over test with 120 s time window.
function pMov = calc_moving_PI(fish)
scores = fish.Res.PItime(4).Scores;
posLabel = scores == 1;
negLabel = scores == -1;
testInterval = 120; % seconds
frameRate = fish.FrameRate;
windowWidth = testInterval * frameRate;
posSum = movmean(posLabel,windowWidth);
negSum = movmean(negLabel,windowWidth);
pMov = posSum./(posSum + negSum);
end

% measure the linear correlation between two variables
function  Rsq = calc_Rsquare(x, y)
p = polyfit(x,y,1);
yFit = polyval(p,x);
yResid = y - yFit;
SSresid = sum(yResid.^2);
SStotal = (length(y)-1) * var(y);
Rsq = 1 - SSresid / SStotal;

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


function PIs = get_all_PIs(obj)
    fishStack = obj.FishStack;
    numFish = length(fishStack);
    PIs = [];
    for i=1:numFish
        fish = fishStack(i);
        tempPI = cat(2,fish.Res.PItime.PIfish);
        PIs = cat(1,PIs,tempPI);
        
        
        
    end
end









