function output = output_task(obj,task)
  % a is a matrix: "n*1 ABLITZER";
   output=[];
    m = 0;
      for t = 1 :length(obj.FishStack) % number of fish in the fishStack

         if obj.FishStack(t).ExpTask==task
           m = m + 1;
           obj.FishStack(t).ratePerformance();
          % Assign values to output
          output.ID(m) = string(obj.FishStack(t).ID);
          output.Age(m) = obj.FishStack(t).Age;
          output.Task(m) = string(obj.FishStack(t).ExpTask);

          output.DataQuality(m) = obj.FishStack(t).Res.DataQuality;
          % PItime
          output.PITime_Baseline(m) = obj.FishStack(t).Res.PItime(1).PIfish;
          output.PITime_Training(m) = obj.FishStack(t).Res.PItime(2).PIfish;
          output.PITime_Test(m) = obj.FishStack(t).Res.PItime(4).PIfish;

          % PIturn
          output.PITurn_Baseline(m) = obj.FishStack(t).Res.PIturn(1).PIfish;
          output.PITurn_Training(m) = obj.FishStack(t).Res.PIturn(2).PIfish;
          output.PITurn_Test(m) = obj.FishStack(t).Res.PIturn(4).PIfish;

          % PIshock
          output.NumShock(m) = obj.FishStack(t).Res.PIshock.NumShocks;
          output.PIshock(m) = obj.FishStack(t).Res.PIshock.PIfish;

          % Learners 1;non-Learners 0
          output.IfLearned(m) = obj.FishStack(t).Res.IfLearned;
          disp(m);
        end
     end
   end

