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
%   Filename: RESDATA.m
%   Abstract: 
%       This class stores results of quantitative analysis on fish's
%       behavioral output(such as turning) and task performance.
%
%   
%   
%   Current Version: 1.1
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Modified on: May 5, 2018
% 
%   Replaced Version: 1.0
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Created on: May 3, 2018
% 

classdef RESDATA
    properties
        DataQuality = NaN; % the percent of valid points
        % Task performance elevation based on time
        PItime = struct('Phase','','Scores',[],'PIfish',NaN);
        % Task performance elevation based on turning behaviors
        PIturn = struct('Phase','','TurnTiming',[],...
            'PreAngle',[],'PostAngle',[],'AngleChange',[],...
            'TurnPos',[],'PatternIdx',[],'Scores',[],'PIfish',NaN);
        % Task performance elevation based on received shocks
        PIshock = struct('Phase',[],'ShockTiming',[],...
            'NumShocks',NaN,'Scores',[],'PIfish',NaN);
        
        
    end
end