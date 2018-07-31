Welcome to ABLITZER (Analyzer of [BLITZ][1] Result)
======================
Introduction
------------
ABLITZER (Analyzer of BLITZ Result) is a custom software suite ([MATLAB][2]) to process data produced by BLITZ (Behavioral Learning In The Zebrafish) which is another custom software (c++) that can automatically acquire high-throughtput behavioral data of larval zebrafish in learning tasks.

This software suite can batchly import BLITZ recorded data from yaml files into well-constructed class (ABLITZER). The ABLITZER class has a subclass FISHDATA which stores all behavioral data and experimental context data of a single fish. Also the ABLITZER class provides a classification method to classify data as user like. 

In addition, the software suite provides many plotting methods at different levels. At the top level, ABLITZER class can statistically plot data of dozens of fish in a meaningful way to evaluate fish's performance in the task with significance test in a clear and concise way. At single fish level, the FISHDATA class provides a method to give learning metrics from 3 different perspectives (time, turn and shock) to demonstrate whether the fish learned the trick.

Also, this software is pretty expendable, users can add some properties and methods to classes to fit their own purposes. 

[1]:https://github.com/Wenlab/BLITZ
[2]:https://www.mathworks.com/products/matlab.html

Future Work
-------
1. Add a mind-realization GUI for users to check how good the behavioral algorithms are implemented. Eventually bridge the theory and reality.


Authors
-------

ABLITZER is written by Wenbin Yang. It is originally a  product of the [Wen Lab][3] in the [Department of Life Science](http://biox.ustc.edu.cn/) and the [HEFEI NATIONAL LABORATORY FOR PHYSICAL SCIENCES AT THE MICROSCALE](http://en.hfnl.ustc.edu.cn/) at [University of Science and Technology of China](http://en.ustc.edu.cn/). 

  [3]:http://www.wenlab.org/
  
  
License
-------
With the exception of certain libraries in the `3rdPartyLibs/` folder, all of ABLITZER is released under the GNU Public License. This means you are free to copy, modify and redistribute this software. 

Contact
-------
Please contact Wenbin Yang, bysin7 (at) gmail (dot) com with questions or feedback.


Compatibility
--------------
ABLITZER is compatible with MATLAB 2017a and later.
Some functions may not work well since some used build-in functions only introduced after MATLAB 2017a.
People use MATLAB with earlier versions may need to update some functions to make the ABLITZER function well.
