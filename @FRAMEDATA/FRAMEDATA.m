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
%   Filename: FRAMEDATA.m
%   Abstract: 
%       This class stores extracted info from a single camera frame, which
%       mainly consists of fish motion data such as position and heading
%       angle.
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
classdef FRAMEDATA
    
    properties  
        %% Experiment time info
        FrameNum = NaN; % index of recorded frame      
        % index of experiment phase from 0.
        % Normally, 0-baseline, 1-training, 2-blackout, 3-test
        ExpPhase = NaN; 
        TimeElapsed = NaN; % in seconds
        
        %% Fish motion info
        Head = [NaN, NaN]; % x,y positions in pixel
        Tail = [NaN, NaN];
        Center = [NaN, NaN];
        HeadingAngle = NaN; % fish's heading angle in degrees
        
        %% External stimulus info
        PatternIdx = NaN; % which visual pattern presented to fish
        ShockOn = NaN; % whether fish received a electric shock
        
    end
    
    methods
    end
    
end