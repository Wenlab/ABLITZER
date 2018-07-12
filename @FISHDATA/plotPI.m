% Plot PI versus time
% TODO: update x, y labels to match time and turn cases
% drop shock case
function plotPI(obj,mStr)
if contains(mStr,'time','IgnoreCase',true)
    PI = obj.Res.PItime;
elseif contains(mStr,'turn','IgnoreCase',true)
    PI = obj.Res.PIturn;
elseif contains(mStr,'shock','IgnoreCase',true)
    PI = obj.Res.PIshock;
else
    error('No Pattern to Match.');
end


figure;
numSubplot = length(cat(1,PI.PIfish));
ns = 0;
for i = 1:length(PI)
   if (isempty(PI(i).Scores))
       continue;
   end
   ns = ns + 1; % position in the subplot
   s = PI(i).Scores;
   idx = find(s);
   s = s(idx);
   c = cumsum(s)./(1:length(s))';
   p = 1-(1-c)/2;
   t = (1:length(c))/obj.FrameRate;
   subplot(numSubplot,1,ns);
   plot(t,p);
   ylim([0,1]);
   ylabel(PI(i).Phase);
   if i == 1
       title(['PI',mStr,' change over time']);
   elseif i == 4
       xlabel('Time (s)');
   end
  
  
end


end