% demo script to run get data from yaml of high/low resolution.

% For high resolution
startFrame_high = 3156;
endFrame_high = 94734;
high_result = Mcd_Frame.yaml2matlab(startFrame_high,endFrame_high,'high');
CrossedAngle = cat(1,high_result.CrossedAngle);

% For low resolution
startFrame_low = 3651;
endFrame_low = 99172;
low_result = Mcd_Frame.yaml2matlab(startFrame_low,endFrame_low,'low');
BendingAngle = cat(1,low_result.BendingAngle);

