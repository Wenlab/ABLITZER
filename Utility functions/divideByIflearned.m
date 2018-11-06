% Remove the bad points, divide into "Learners" and "non-Learners"
function [Learners,non_Learners] = divideByIflearned(a)
%% rename this function as "classifyLearners"

for i=1:length(a)
     a(i).remove_invalid_data_pair;
     for j=1:length(a(i).FishStack)
       sayExtTimeandIfLearned(a(i).FishStack(j));
    end
end

Learners = divideBylearning(a,1);
non_Learners = divideBylearning(a,0);
end

function members = divideBylearning(a,m)
    members=[];
    q=1;
   for k = 1:length(a)

    for t =1:length(a(k).FishStack) % number of fish in the fishStack
        if a(k).FishStack(t).Res.IfLearned ==m & a(k).FishStack(t).ExpTask=="OLexp"

           members.FishStack(q)= a(k).FishStack(t);
           q=q+1;
        end
    end
          disp(t);
   end
 end
