function mcdf=yaml2matlab(startFrame,endFrame,flag)
% This function reads in a yaml file produced by the MindControl Software
% and exports an array of MindControl Data Frames (mcdf's) that is easy to
% manipulate in matlab.
%
% Andrew Leifer
% leifer@fas.harvard.edu
% 2 November 2010

[filename,pathname] = uigetfile('*.yaml');
file = [pathname filename];
fid = fopen(file); 

Mcd_Frame.seekToFirstFrame(fid);
k=1;
while(~feof(fid))
    if k < startFrame
        Mcd_Frame.readOneFrame(fid,flag);
    else
        mcdf(k-startFrame+1)=Mcd_Frame.readOneFrame(fid,flag); %#ok<AGROW>
    end
    k=k+1;
    if ~mod(k,100)
        disp(k);
    end
    if k > endFrame % DIY
        break;
    end
end
fclose(fid);

