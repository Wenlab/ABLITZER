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
        [~,pathName] = uigetfile('F:\FishExpData\operantLearning\*.yaml');
        expDate = inputdlg('Enter the experiment date (e.g. 20180206)');
        expDate = expDate{1};
    end
    
    saveMatName = [pathName,expDate,'.mat'];
    % if file exists, load the file, then return
    if exist(saveMatName,'file') == 2
        fprintf('A saved result in .mat available,\n please import the data directly\n');
%        fprintf('Load the mat file:\n %s\n',[pathName,expDate,'.mat']);
%         oldData = load(saveMatName);
%         aObj = oldData.obj;
%         output = oldData.output;
%         % attach old fishStack
%         obj.FishStack = cat(1,obj.FishStack, aObj.FishStack);
        return
    end
    
    
    d = dir([pathName,'*.yaml']);
    output = struct('ExpTime',[],'FishID',[],'Age',[],'Task',[],'DataQuality',[],...
    'PITime_Baseline',[],'PITime_Training',[],'PITime_Test',[],...
    'PITurn_Baseline',[],'PITurn_Training',[],'PITurn_Test',[],...
    'NumShock',[],'PIShock',[]);
    
    numFiles = length(d);
    
    n = 0; % index of experiment files to analyze
    for i=1:numFiles
        fName = d(i).name;
        if (contains(fName,expDate)) 
            n = n + 1;
            fprintf('Read the yaml file:\n %s\n',fName);
            obj.oldYaml2matlab(-1,pathName,fName);              
            
        end      
    end
    
    numFish = length(obj.FishStack); % number of fish in the fishStack
    for i = 1:numFish
        obj.FishStack(i).ratePerformance();   
        % Assign values to output
        output(i).ExpTime = obj.FishStack(i).ExpStartTime;
        output(i).FishID = obj.FishStack(i).ID;
        output(i).FishAge = obj.FishStack(i).Age;
        output(i).Task = obj.FishStack(i).ExpTask;
        
        output(i).DataQuality = obj.FishStack(i).Res.DataQuality;
        % PItime
        output(i).PITime_Baseline = obj.FishStack(i).Res.PItime(1).PIfish;
        output(i).PITime_Training = obj.FishStack(i).Res.PItime(2).PIfish;
        output(i).PITime_Test = obj.FishStack(i).Res.PItime(4).PIfish;
        
        % PIturn
%         output(i).PITime_Baseline = obj.FishStack(i).Res.PIturn(1).PIfish;
%         output(i).PITime_Training = obj.FishStack(i).Res.PIturn(2).PIfish;
%         output(i).PITime_Test = obj.FishStack(i).Res.PIturn(4).PIfish;
%         
%         % PIshock
%         output(i).NumShock = obj.FishStack(i).Res.PIshock.NumShocks;
%         output(i).PIshock = obj.FishStack(i).Res.PIshock.PIfish;       
    end
    
    
    save(saveMatName,'output','obj');


end