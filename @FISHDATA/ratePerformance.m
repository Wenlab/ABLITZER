% Rate fish performance in the task
function ratePerformance(obj)
    obj.evaluateDataQuality();
    obj.calcPItime();
    obj.calcPIturn();
    %obj.ratePerformanceByTrials('time',false);
    %obj.ratePerformanceByTrials('turn',false);
    obj.calcPIshock();
    %plot_PI_versus_time(obj);
end

