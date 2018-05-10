%   Copyright 2018 Wenbin Yang <bysin7@gmail.com>
%   This file is part of A-BLITZ-ER[1] (Analyzer of Behavioral Learning 
%   In The ZEbrafish Result.) i.e. the analyzer of BLITZ[2]. 
%
%   BLITZ (Behavioral Learning In The Zebrafish) is a software that 
%   allows researchers to train larval zebrafish to associate 
%   visual pattern with electric shock in a fully automated way, which 
%   is adapted from MindControl.[3]
%   [1]: https://github.com/Wenlab/ABLITZER
%   [2]: https://github.com/Wenlab/BLITZ
%   [3]: https://github.com/samuellab/mindcontrol
%
%
%   Filename: quantifyFishOLperformance.m (method of ABLIZTER class)
%   Abstract: 
%      evaluate fish performance from 3 different perspectives:
%        1. Time spent in each half
%        2. Turns performed near the partition-line
%        3. Shocks received during training session
%
%   SYNTAX:
%       
%   INPUT:
%  
%   OUTPUT: 
%       Implicit output, saved in the object of ABLITZER class.
% 
% 
% 
% 
% 
% 
%   
%   Current Version: 1.1
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Modified on: May 6, 2018
% 
%   Replaced Version: 1.0
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Created on: May 3, 2018
% 
function quantifyFishOLperformance(obj)


















end

% Since the abnormal abrupt change of head positions is a sign of bad
% points, so the percent of bad points can be used as a metric to evaluate
% the data quality for each fish. 
% TODO?: replace the 2nd term in numBadPts by recorded framesUnmoved in yaml
function evaluateDataQuality()
    % Constant Parameters
    distThre = 100;

    expData = obj.ExpData;
    for i=1:length(expData(1).FishData)
        head = cat(1,expData.FishData(i).Head);
        headDiff = diff(head);
        headChange = sqrt(headDiff(:,1).^2 + headDiff(:,2).^2);
        % the second term measures frames fish unmoved for at least 1
        % seconds
        numBadPts = length(find(headChange > distThre))...
            + length(find(smooth(headChange,10) == 0));
        obj.ExpData.FishData(
    end
end
















