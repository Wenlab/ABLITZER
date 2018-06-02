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
%   Filename: processOneDayYamls.m
%   Abstract: 
%       Patchly process experimental data in fish operant learning(OL) task
%  
%-------------------------------------------------------------
% SYNTAX
%
%
%-------------------------------------------------------------
% INPUT
%
%
%--------------------------------------------------------------
% OUTPUT
%
%   
%   
%   Current Version: 1.2
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Modified on: May 9, 2018
% 
%   Orinigal Version: 1.0
%   Author: Wenbin Yang <bysin7@gmail.com>
%   Created on: May 3, 2018
% 
function output = processOneDayYamls(obj,pathName,expDate)

    if nargin == 3
        % do nothing, since supplied by argument list
    elseif nargin == 2   
        expDate = inputdlg('Enter the experiment date (e.g. 20180206)');
        expDate = expDate{1};
    elseif nargin == 1
        [fileName,pathName] = uigetfile('F:\Project-Operant Learning in Larval Zebrafish\ExpDataSet\*.yaml');
        expDate = fileName(1:8); % get the string of exp date
    end
    
    d = dir([pathName,'*.yaml']);
    numFiles = length(d);
    for i=1:numFiles
        fName = d(i).name;
        if (contains(fName,expDate)) 
            fprintf('Read yaml file:\n %s\n',fName);
            obj.yaml2matlab(false,pathName,fName);                         
        end      
    end
    
    output = generate_output(obj);
end

% Generate an output struct for checking all results in the same place
function output = generate_output(obj)
    output = struct('ID',[],'Age',[],'Task',[],'DataQuality',[],...
    'PITime_Baseline',[],'PITime_Training',[],'PITime_Test',[],...
    'PITurn_Baseline',[],'PITurn_Training',[],'PITurn_Test',[],...
    'NumShock',[],'PIShock',[]);
    for i = 1:length(obj.FishStack)% number of fish in the fishStack
        obj.FishStack(i).ratePerformance();   
        % Assign values to output
        output(i).ID = obj.FishStack(i).ID;
        output(i).Age = obj.FishStack(i).Age;
        output(i).Task = obj.FishStack(i).ExpTask;
        
        output(i).DataQuality = obj.FishStack(i).Res.DataQuality;
        % PItime
        output(i).PITime_Baseline = obj.FishStack(i).Res.PItime(1).PIfish;
        output(i).PITime_Training = obj.FishStack(i).Res.PItime(2).PIfish;
        output(i).PITime_Test = obj.FishStack(i).Res.PItime(4).PIfish;
        
        % PIturn
        output(i).PITurn_Baseline = obj.FishStack(i).Res.PIturn(1).PIfish;
        output(i).PITurn_Training = obj.FishStack(i).Res.PIturn(2).PIfish;
        output(i).PITurn_Test = obj.FishStack(i).Res.PIturn(4).PIfish;
        
        % PIshock
        output(i).NumShock = obj.FishStack(i).Res.PIshock.NumShocks;
        output(i).PIshock = obj.FishStack(i).Res.PIshock.PIfish;       
    end
    
end
