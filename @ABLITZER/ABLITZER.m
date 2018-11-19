
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
%   Filename: ABLITZER.m
%   Abstract:
%       The main class is defined in this file, it is ...
%       A class with data structure, stores the experimental data of the
%       entire data set about an experiment, including both categoried
%       recorded data from yaml files and analysis results at statistical
%       level. It also provides some functions:
%
%       1. Read in yaml file
%       2. Evaluate fish performance in the task from multiple perspectives
%       3. Visualize the quatitative statistical results in figures with
%          optional annotations
%
%
%
%   Current Version: 2.0
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Modified on: Sep. 27, 2018
%
%   Orinigal Version: 1.0
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Created on: May 3, 2018
%



classdef ABLITZER < handle % Make the class a real class not a value class
    
    properties
        FishStack; % Stack to store all fish data
        % Devide fishStack into different groups based on different tags
        % Put idx of data in 2nd column
        FishGroups = struct('Value',[],'idxData',[],'Key',[],'Note',[]);
        StatRes; % statistical results about the entire experiment
        
        Notes = ''; % additional notes about the dataset
    end
    
    methods
        % Reads in a yaml file produced by the BLITZ software
        % and exports a struct of BLITZ experiment data that is
        % easy to manipulate in MATLAB
        loadYamls(obj, fileNames, pathName, keywords, loadMethod, oldFlag);
        
        % load mat files which matches keys provided in the same directory
        loadMats(obj, fileNames, pathName, keywords, loadMethod);
        
        % save FishData into different files based on keys
        saveData(obj, keys, savingPath, maxFileSize);
        
        % remove fish data whose data quality lower than threshold
        removeInvalidData(obj,ifPaired,qualThre);
        
        % classify data into different groups by keys. (e.g. Experiment
        % Type): To Improve
        classifyFish(obj, keys);
        
        % Find desired fish by providing key-value pairs
        indices = findFish(obj,varargin);
        
        % Rate performances for all fish
        rateAllFish(obj);
        
        % Find all learners in FishStack
        [idxL, idxNL] = findLearners(obj);
        
        % Plot performance index (positional/turning) of different groups 
        % (1. exp only; 2. with self-control; 3. with unpaired control)
        % Normally, use this function
        % after "classifyFishByKeys".
        plotPIs(obj,numGroups,metric);
        
        % plot learning curves of learners, non-learners, and the all
        plotLearningCurves(obj, metric, whichClass);
        
        % list all KPIs in a struct
        output = outputFeatures(obj);
        
        
        
    end
end
