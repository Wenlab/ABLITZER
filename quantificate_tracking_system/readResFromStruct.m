fishPara = cell(13,4);
for i=1:13
    for j=1:4
        if j == 1
            fishPara{i,j} = cat(1,low_result(lowCutMat(i,1):lowCutMat(i,2)).BendingAngle);
        elseif j == 2
            fishPara{i,j} = cat(1,low_result(lowCutMat(i,2):lowCutMat(i,3)).BendingAngle);
        elseif j == 3
            fishPara{i,j} = cat(1,high_result(highCutMat(i,1):highCutMat(i,2)).CrossedAngle);
        elseif j == 4
            fishPara{i,j} = cat(1,high_result(highCutMat(i,2):highCutMat(i,3)).CrossedAngle);
        end
    end
end

indexLowVideo = struct('startFrame',0,'startPrey',0,'endFrame',0);
indexHighVideo = struct('startFrame',0,'startPrey',0,'endFrame',0);
for i=1:13
    for j=1:3
        if j == 1
            indexLowVideo(i).startFrame = lowCutMat(i,j);
            indexHighVideo(i).startFrame = highCutMat(i,j);
        elseif j == 2
            indexLowVideo(i).startPrey = lowCutMat(i,j);
            indexHighVideo(i).startPrey = highCutMat(i,j);
        elseif j == 3
            indexLowVideo(i).endFrame = lowCutMat(i,j);
            indexHighVideo(i).endFrame = highCutMat(i,j);
        end
    end
end
