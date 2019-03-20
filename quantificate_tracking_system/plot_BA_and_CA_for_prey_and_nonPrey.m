function plot_BA_and_CA_for_prey_and_nonPrey(BAprey,BAnonPrey,CAprey,CAnonPrey)
    frameRate = 100;
    figure;
    subplot(2,2,1);
    BA1 = diff(BAprey);
    BA2 = smooth(BA1);
    
    t = (1:length(BA2))/frameRate;
    
    plot(t,BA2);
    ylim([0,180]);
    title('Change of tail bending angle in prey');
    ylabel('Angle (deg)');
    xlabel('Time (s)');
    
    
    subplot(2,2,2);
    t = (1:length(CAprey))/frameRate;
    plot(t,CAprey);
    ylim([0,180]);
    title('Eye convergence angle in prey');
    ylabel('Angle (deg)');
    xlabel('Time (s)');
    
    subplot(2,2,3);
    BA1 = diff(BAnonPrey);
    BA2 = smooth(BA1);
    
    t = (1:length(BA2))/frameRate;
    plot(t,BA2);
    ylim([0,180]);
    title('Change of tail bending angle not in prey');
    ylabel('Angle (deg)');
    xlabel('Time (s)');
    
    subplot(2,2,4);
    t = (1:length(CAnonPrey))/frameRate;
    plot(t,CAnonPrey);
    ylim([0,180]);
    title('Eye convergence angle not in prey');
    ylabel('Angle (deg)');
    xlabel('Time (s)');
    
end