% Generate an output struct for checking all results in the same place
function output = generate_output(a)
  % a is a matrix: "n*1 ABLITZER";
output = struct('ID',[],'Age',[],'Task',[],'DataQuality',[],...
'PITime_Baseline',[],'PITime_Training',[],'PITime_Test',[],...
'PITurn_Baseline',[],'PITurn_Training',[],'PITurn_Test',[],...
'NumShock',[],'PIShock',[]);
output=[];
end_idx = 0;
m = 0;
for j = 1:length(a)
    t = 0;
    begin_idx = end_idx+1;
    end_idx = end_idx + length(a(j).FishStack);
  for i = begin_idx :end_idx % number of fish in the fishStack
      t = t + 1;

    a(j).FishStack(t).ratePerformance();
    % Assign values to output
    output(i).ID = a(j).FishStack(t).ID;
    output(i).Age = a(j).FishStack(t).Age;
    output(i).Task = a(j).FishStack(t).ExpTask;

    output(i).DataQuality = a(j).FishStack(t).Res.DataQuality;
    % PItime
    output(i).PITime_Baseline = a(j).FishStack(t).Res.PItime(1).PIfish;
    output(i).PITime_Training = a(j).FishStack(t).Res.PItime(2).PIfish;
    output(i).PITime_Test = a(j).FishStack(t).Res.PItime(4).PIfish;

    % PIturn
    output(i).PITurn_Baseline = a(j).FishStack(t).Res.PIturn(1).PIfish;
    output(i).PITurn_Training = a(j).FishStack(t).Res.PIturn(2).PIfish;
    output(i).PITurn_Test = a(j).FishStack(t).Res.PIturn(4).PIfish;

    % PIshock
    output(i).NumShock = a(j).FishStack(t).Res.PIshock.NumShocks;
    output(i).PIshock = a(j).FishStack(t).Res.PIshock.PIfish;
end
end
end
