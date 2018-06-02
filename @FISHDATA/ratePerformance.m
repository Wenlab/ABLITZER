% Rate fish performance in the task
function ratePerformance(obj)
    obj.evaluateDataQuality();
    obj.calcPItime();
    obj.calcPIturn();
    obj.calcPIshock();
    %plot_PI_versus_time(obj);
end

