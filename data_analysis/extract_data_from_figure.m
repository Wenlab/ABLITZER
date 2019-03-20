function [xdata,ydata,zdata] = extract_data_from_figure(h)
    % h is the handle of current figure
    axesObjs = get(h, 'Children');  %axes handles
    dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes
    
    objTypes = get(dataObjs, 'Type');  %type of low-level graphics object
    
    xdata = get(dataObjs, 'XData');  %data from low-level grahics objects
    ydata = get(dataObjs, 'YData');
    zdata = get(dataObjs, 'ZData');
end