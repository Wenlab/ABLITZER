% demo for get mass center of fish across the entire video
[filename,pathname]  = uigetfile({'*.avi'});
fname=[pathname filename];
vidObj=VideoReader(fname);
numFrames = get(vidObj,'NumberOfFrames');

MCcell = cell(numFrames,1);
vidObj=VideoReader(fname);
parfor i=1:numFrames
    disp(i);
    frame = readFrame(vidObj);
    grayImg = rgb2gray(frame);
    bwFish = extract_fish(grayImg);
    %figure(1);
    %imshow(bwFish);
    %pause(0.01);
    [Cx,Cy]=get_mass_center(bwFish);
    
    MCcell{i,1} = [Cx,Cy];
end