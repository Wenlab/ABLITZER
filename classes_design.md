### Key words explainations
- cases: different conditioned patterns / different visual intensity ratios
- groups: fish groups trained with different experiment protocols (self-control group, experiment group, unpaired-control group)
- classes: learners, non-learners, (all fish) which classified by the learning metrics (currently the significance test of the positional indices)


## Loading/Saving functions
- loadMats(byKeywords): append fishStack to an existing ABLITZER obj
  - ABLITZER method
  - arg1: keywords to filter files
  - arg2: append data / rewrite Data


## Analysis functions

## Plotting functions
- plotPIs: plot performance index (positional/turning/shock) of different groups (1. exp only; 2. with self-control; 3. with unpaired control)
  - ABLITZER method
  - arg1: metric type (positional/turning/shock)
  - arg2: (number of arguments) which groups to plot (1. exp only; 2. with self-control; 3. with unpaired control)

- plotDistance2centerline:
  - (FishData method)
  - arg1: the entire process / test-phase only / baseline-phase / training-phase
  - arg2: pixelSize
  - arg3: w/o extinction point (blue triangle)
  - arg4: w/o shocking events (red filled-circles)
  - arg5: w/o shadows to demarcate consecutive phases

- plotLearningCurves: plot performance index (positional/turning/shock) of different classes (1. learners only; 2. with non-learners; 3. with all)
  - ABLITZER method
  - arg1: metric type (positional/turning/shock)
  - arg2: which classes to plot (1. learners only; 2. with non-learners; 3. with all)

- histPlotMemLen: plot the histograms of memory lengths of different cases
  - ABLITZER method
  - arg1: which case(s) to plot. (white-black checkerboard, red-black checkerboard, pure-black patterns)
  - arg2: binEdges/width

- plotOntogeny: plot different metrics (memory length, positional index increments, turning index increments) versus ages.
  - ABLITZER method
  - arg1: ages
  - arg2: corresponding indices to ages
  - arg3: metrics (memory length, positional index increments, turning index increments)
