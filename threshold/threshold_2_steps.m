function [ ] = threshold_2_steps( )
%Summary of this function goes here
%   Detailed explanation goes here
% Use 2-steps algorithm to make grayscale image into binary image and
% fininally get a clear and complete boundary of the fish.
[FileName,PathName] = uigetfile('*.avi');
filename = [PathName,FileName];
v = VideoReader(filename);

while 1
frame = readFrame(v);
grayScale = rgb2gray(frame);
%imshow(grayScale);
thre1 = graythresh(grayScale); % tentative threshold

BW1 = im2bw(grayScale,thre1);
CC = bwconncomp(BW1); % find connected components in binary image.
idx = [];
pixelIdxList = CC.PixelIdxList;
for i = 1:length(pixelIdxList)
    if length(pixelIdxList{1,i}) > 10000
        idx = [idx;pixelIdxList{1,i}];
    end
end

threshedImg1 = grayScale;
threshedImg1(idx) = 0;

thre2 = graythresh(threshedImg1);
BW2 = im2bw(threshedImg1,thre2);
%figure;
imshow(BW2);
pause(0.1);

end
end

