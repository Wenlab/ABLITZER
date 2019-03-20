classdef Mcd_Frame
    %mind control data
    properties
        FrameNumber = NaN; %internal frame number, not nth recorded frame
        TimeElapsed = NaN; %time since start of experiment (in s)
        TimeStamp = NaN; 
        EyeOrientation = [NaN NaN]; %orientation of left eye and right eye
        CrossedAngle = NaN; % cressed angle of two eyes.
        LEDIsOn = NaN; % if LFD is on   
        
        % low resolution
        BendingAngle = NaN; % bending angle of tail of fish
    end
    
    methods (Static)
        mcdf_arr = yaml2matlab(startFrame,endFrame,flag);
        mcdf = readOneFrame(fid,flag);
        success = seekToFirstFrame(fid);
    end
        
end
    
