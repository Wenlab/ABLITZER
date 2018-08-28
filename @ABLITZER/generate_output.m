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
