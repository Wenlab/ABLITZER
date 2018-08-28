

function [output,output_OLcontrol,output_OLexp,aver] = plot_bar(a)

  output = struct('ID',[],'Age',[],'Task',[],'DataQuality',[],...
  'PITime_Baseline',[],'PITime_Training',[],'PITime_Test',[],...
  'PITurn_Baseline',[],'PITurn_Training',[],'PITurn_Test',[],...
  'NumShock',[],'PIShock',[]);

   begin_idx = 1;
   end_idx = 0;
   num = length(a);

  for j = 1:num

  t = 0;
  begin_idx = begin_idx + end_idx;
  end_idx = end_idx + length(a(j).FishStack);
  for i = begin_idx:end_idx% number of fish in the fishStack
       t = t+1;
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
      disp(i);

  end
  end

 C=zeros();
  a=1;
  for i=1:length(output)
    if output(i).Task=="OLcontrol";
      C(a)=i;
      a=a+1;
     end
 end
  E=zeros();
 a=1;
 for i=1:length(output)
   if output(i).Task=="OLexp";
     E(a)=i;
     a=a+1;
    end
end
  output_OLcontrol=output;
  output_OLexp=output;
  t=0;
  for i=1:length(C)
   q=C(i)-t;
   t=t+1;
   output_OLexp(q)=[];
  end
  t=0;
  for i=1:length(E)
   q=E(i)-t;
   t=t+1;
   output_OLcontrol(q)=[];
  end


  Bad=zeros();
  a=1;

 numPairs=length(output_OLexp);
  for i=1:numPairs

       if (output_OLexp(i).DataQuality < 0.95) || (output_OLcontrol(i).DataQuality < 0.95)
           Bad(a)=i;
           a=a+1;
       end
  end

  t=0;
  for i=1:length(Bad)
   q=Bad(i)-t;
   t=t+1;
   output_OLcontrol(q)=[];
   output_OLexp(q)=[];
  end

  aver = struct('Task',[],'PITime_Baseline',[],'PITime_Test',[],'PITurn_Baseline',[],'PITurn_Test',[]);
  aver(1).Task="OLcontrol";
  aver(2).Task="OLexp";

  num = length(output_OLcontrol);
  sum = 0;
  for i = 1:num
    sum = sum + output_OLcontrol(i).PITime_Baseline;
  end
  aver(1).PITime_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLcontrol(i).PITime_Test;
  end
  aver(1).PITime_Test = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLcontrol(i).PITurn_Baseline;
  end
  aver(1).PITurn_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLcontrol(i).PITurn_Test;
  end
  aver(1).PITurn_Test = sum / num;


  sum = 0;
  for  i = 1:num
    sum = sum + output_OLexp(i).PITime_Baseline;
  end
  aver(2).PITime_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLexp(i).PITime_Test;
  end
  aver(2).PITime_Test = sum / num;

  sum = 0;
  for i = 1:num
    sum = sum + output_OLexp(i).PITurn_Baseline;
  end
  aver(2).PITurn_Baseline = sum / num;

  sum = 0;
  for  i = 1:num
    sum = sum + output_OLexp(i).PITurn_Test;
  end
  aver(2).PITurn_Test = sum / num;

y1=[aver(1).PITime_Baseline,aver(1).PITime_Baseline;aver(2).PITime_Baseline,aver(2).PITime_Baseline;]
y2=[aver(1).PITurn_Baseline,aver(1).PITurn_Baseline;aver(2).PITurn_Baseline,aver(2).PITurn_Baseline;]
figure;
b=bar(y1);

b(1).FaceColor = [0.9,0.9,0.9];
b(2).FaceColor = [0,0,0];
axis([0 3 0 1])
set(gca,'xtick',-inf:inf:inf);
ylabel('Poisitional Index');
xlabel('Self-Control                 Experiment');

figure;
b=bar(y1);
b(1).FaceColor = [0.9,0.9,0.9];
b(2).FaceColor = [0,0,0];
axis([0 3 0 1])
set(gca,'xtick',-inf:inf:inf);
ylabel('Turning Index');
xlabel('Self-Control                 Experiment');
end
