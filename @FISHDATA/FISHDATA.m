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
%   Filename: FISHDATA.m
%   Abstract:
%       This class stores all data for a single fish, includes recorded
%       experimental data from yaml and analysis result.
%
%
%
%   Current Version: 1.3
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Modified on: July 12, 2018
%
%   Replaced Version: 1.0
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Created on: May 3, 2018
%

classdef FISHDATA < matlab.mixin.SetGet % inherit get method

    properties
        %% Personal Data of Fish
        ID = ''; % ID of fish in the experiment
        Age = NaN; % dpf (day past fertilization)
        Strain = ''; % strain of fish

        %% General info about the experiment the fish was in
        Arena = NaN; % which arena the fish was in
        ExpStartTime = ''; % start time of the experiment (ss-mm-hh, dd-mm-yy)
        ExpTask = ''; % the learning task of experiment (e.g. Operant Learning)
        CSpattern = ''; % the conditioned pattern used in the exp,
        % the default non-CS pattern is mid-gray (128,128,128)
        ExpType = ''; % experiment group or control group?
        ExpNote = ''; % additional detail info about the experiment

        FrameRate = NaN; % frame rate of the camera used in the experiment
        ConfinedRect = [NaN, NaN, NaN, NaN]; % [topLeft_x, topLeft_y, width, height] in pixels
        yDivide = NaN; % pixel, Y position to equally devide the patch into CS and NCS area

        %% Recorded frame-updated data about time and fish motion
        Frames; % numFrames * 1 objects of FRAMEDATA

        %% Analysis Results of fish's performance in the task
        Res = RESDATA;






    end

    methods

        % Rate fish performance in the task
        ratePerformance(obj);

        % Evaluate data quality based on bad points percentage
        evaluateDataQuality(obj);

        % Rate fish performance based on time spent on non-CS area
        calcPItime(obj);

        % Calculate performance indes based on turning events
        calcPIturn(obj);

        % Calculate performance indes based on shocks received
        calcPIshock(obj);

        % Calculate fish length from head to tail
        bodyLength = calcFishLen(obj);

        % Calculate fish swimming speed
        swimSpeed = calcSwimSpeed(obj,expPhase);

        % Measure the memory extinction in the task
        extTime = measureExtinction(obj);

        % Fish personal analysis
        TrRes = personalAnalysis(obj,idxPostTr);

        % Measure whether fish learned or not
        [h, p, extincTime] = sayIfLearned(obj,metric,plotFlag);

        % Measure self-abusement in fish
        [h, p] = sayIfSelfAbused(obj,metric,plotFlag);

        % Rate performance by trials, every 2 mins is counted as a trial
        TrRes = ratePerformanceByTrials(obj,metric,plotFlag);

        % Calculate reaction time for each trial
        reactionTime = calcReactTimeByTrials(obj);

        % Get start index, end index and expPhase for each trial
        % Every pattern change is counted as a trial
        TrMat = getTrIndices(obj);

        % Plot learning curve by PIs in each trial in training
        resMat = plotLearningCurveByTrials(obj,metric);

        % plot distance to centerline over time
        plotDist2centerline(obj,phase,varargin);
        % Plot distance to centerline of the arena for a FISHDATA.

        plotPI(obj,mStr);
        % Annotate raw video with fish's head, tail and CS pattern
        annotateRawVideo(obj,startFrame,videoName);

        [extTime,num_trail,Test_trail,meanBT] = sayExtTimeandIfLearned(obj);

        Trail=measure_trail(obj,m)
    end




end
