### Key words explainations
- cases: different conditioned patterns / different visual intensity ratios
- groups: fish groups trained with different experiment protocols (self-control group, experiment group, unpaired-control group)
- classes: learners, non-learners, (all fish) which classified by the learning metrics (currently the significance test of the positional indices)


## Loading/Saving functions
- [x] loadMats(byKeywords): append fishStack to an existing ABLITZER obj
  - ABLITZER method
  - arg1: keywords to filter files
  - arg2: append data / rewrite Data

- [x] loadYamls(byKeywords): import yaml files to matlab
  - ABLITZER method
  - arg1: keywords to filter files
  - arg2: append data / rewrite Data
  - arg3: old-flag to deal with old yaml files

- [x] saveData(by keywords/size): save fishStack in ABLITZER obj into multiples files
  - ABLITZER method
  - arg0: savingPath
  - arg1: which keywords to be classified
  - arg2: size to be divided

- saveTrialsMat: save trial-by-trial mat in files
  - global function
  - structure needs to be defined

## Utility functions (classification/finding/search for)
- [x] classifyFish： classify fish in groups by keys (e.g., ages, strains)
  - ABLITZER method

- [x] findFish: find specific fish by key-value pair or keywords
  - ABLITZER method

- [x] removeInvalidData: remove FISHDATA (in pair) whose data quality lower than the threshold
  - ABLITZER method

- outputFeatures: output as print-out message/variable (struct)
  - ABLITZER method
  - arg1: indices to output (all/selective)

## Analysis functions
- [x] evaluateDataQuality:
- [x] calcPItime(PositionalIndex):
  - FISHDATA method
  - phaseByPhase
    - add trials' values for each phase
    - add increments in RESDATA
- [x] calcPIturn(TurningIndex):
  - FISHDATA method
  - phaseByPhase
    - add trials' values for each phase
    - add increments in RESDATA
- [x] calcPIshock(ShockIndex):
  - FISHDATA method
  - phaseByPhase
    - add trials' values for each phase
- [x] [ifLearned, MemLen] = sayIfLearned
  - FISHDATA method
  - add "MemoryLength" in seconds
  - "ExtinctTime" should be converted to the idxFrame / seconds from the experiment beginning.

## Plotting functions
- [x] plotPIs: plot performance index (positional/turning/shock) of different groups (1. exp only; 2. with self-control; 3. with unpaired control)
  - ABLITZER method
  - arg1: metric type (positional/turning/shock)
  - arg2: (number of arguments) which groups to plot (1. exp only; 2. with self-control; 3. with unpaired control)

- [ ] plotDistance2centerline:
  - (FishData method)
  - arg1: the entire process / test-phase only / baseline-phase / training-phase
  - arg2: pixelSize
  - arg3: w/o extinction point (blue triangle)
  - arg4: w/o shocking events (red filled-circles)
  - arg5: w/o shadows to demarcate consecutive phases

- [ ] plotLearningCurves: plot performance index (positional/turning/shock) of different classes (1. learners only; 2. with non-learners; 3. with all)
  - ABLITZER method
  - arg1: metric type (positional/turning/shock)
  - arg2: which classes to plot (1. learners only; 2. with non-learners; 3. with all)
  - we can also design a global function to deal with saved trialBytrialPImat.

- [ ] histPlotMemLen: plot the histograms of memory lengths of different cases
  - ABLITZER method
  - arg1: which case(s) to plot. (white-black checkerboard, red-black checkerboard, pure-black patterns)
  - arg2: binEdges/width

- [ ] plotOntogeny: plot different metrics (memory length, positional index increments, turning index increments) versus ages.
  - ABLITZER method
  - arg1: ages

## Demo scripts
- plot Figures 1-4
- basic usages
  - arg2: corresponding indices to ages
  - arg3: metrics (memory length, positional index increments, turning index increments)
