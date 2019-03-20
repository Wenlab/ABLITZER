classdef Mcd_Frame
    %mind control data
    properties
        FrameNumber = NaN; %internal frame number, not nth recorded frame
        TimeElapsed = NaN; %time since start of experiment (in s)
        TimeStamp = NaN %time stamp on each frame (in ns)
        EyeOrientation = [NaN NaN];
        CrossedAngle = NaN;
        Head = [NaN NaN]; %position in pixels on camera
        Tail = [NaN NaN]; %position in pixels on camera
        BoundaryA = [1:200]*NaN; %2*N length vector xyxyxy position in pixels on camera
        BoundaryB = [1:200]*NaN; %2*N length vector xyxyxy position in pixels on camera
        SegmentedCenterline = [1:200]*NaN;  %2*N length vector xyxyxy position in pixels on camera
        DLPisOn = 0; %bool whether DLP is active
        FloodLightIsOn =0; %flood light overrides all other patterns and hits entire fov
        IllumInvert =0; %whether pattern is inverted (invert has precedence over floodlight)
        IllumFlipLR =0; %flips output left/right with respect to worm's body
        IllumRectOrigin =0; %center of the freehand rectangular illumination in wormspace
        IllumRectRadius =0; %xy value describing dimension of rectangle
        StageVelocity =0; %velocity sent to stage in stage units/second
        ProtocolIsOn =0; %bool whether you're using protocol
        ProtocolStep =0; %what step within protocol is currently selected
    end
        
end
    
