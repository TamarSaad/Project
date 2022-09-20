%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Check at http://scholar.harvard.edu/yyl/doc for most updated version of the code.
Please contact yyl@channing.harvard.edu with any question regarding the DOC analysis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Content:

The file Doc_tutorial_3.0.zip includes: 

1) OTU table (“OTUtable.txt”): Table of relative abundance of 50 tongue samples from 50 randomly selected different subjects from the HMP website (http://www.hmpdacc.org/HMQCP/). 

2) Matlab script (“script_DOC_analysis.m”): The matlab code imports the abundance table, performs DOC analysis, plots the figures and reports the universality scores.

3) Matlab functions used by the script.

Running the tutorial:

1) Extract the content of the enclosed Doc_tutorial_3.0.zip file to a local directory.

2) Run the “script_DOC_analysis.m” Matlab file. Running time is about 30 sec. for 10 bootstrap realizations. (The code was written on MATLAB R2015a)


Output:

1) Matlab figure showing DOC analysis of the real samples (left) and the null model (middle). 

2) Two universality scores are displayed in the command window: 1) Fns and 2) p-value of the negative slope (fraction of bootstrap realizations for which a negative slope is not observed).


