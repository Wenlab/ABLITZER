function output = output_task(a,task)
  % a is a matrix: "n*1 ABLITZER";
   output=[];
   end_idx = 0;
   m = 0;
   for j = 1:length(a)


     for t = 1 :length(a(j).FishStack) % number of fish in the fishStack

         if a(j).FishStack(t).ExpTask==task
           m = m + 1;
           a(j).FishStack(t).ratePerformance();
          % Assign values to output
          output.ID(m) = string(a(j).FishStack(t).ID);
          output.Age(m) = a(j).FishStack(t).Age;
          output.Task(m) = string(a(j).FishStack(t).ExpTask);

          output.DataQuality(m) = a(j).FishStack(t).Res.DataQuality;
          % PItime
          output.PITime_Baseline(m) = a(j).FishStack(t).Res.PItime(1).PIfish;
          output.PITime_Training(m) = a(j).FishStack(t).Res.PItime(2).PIfish;
          output.PITime_Test(m) = a(j).FishStack(t).Res.PItime(4).PIfish;

          % PIturn
          output.PITurn_Baseline(m) = a(j).FishStack(t).Res.PIturn(1).PIfish;
          output.PITurn_Training(m) = a(j).FishStack(t).Res.PIturn(2).PIfish;
          output.PITurn_Test(m) = a(j).FishStack(t).Res.PIturn(4).PIfish;

          % PIshock
          output.NumShock(m) = a(j).FishStack(t).Res.PIshock.NumShocks;
          output.PIshock(m) = a(j).FishStack(t).Res.PIshock.PIfish;

          % Learners 1;non-Learners 0
          output.IfLearned(m) = a(j).FishStack(t).Res.IfLearned;
          disp(m);
        end
     end
   end
end
