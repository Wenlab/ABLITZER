function [Cx,Cy]=get_mass_center(BW)
    [y,x] = find(BW);
    Cx = sum(x)/length(x);
    Cy = sum(y)/length(y);
end