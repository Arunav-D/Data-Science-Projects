MAtlab - 9.11.0.1809720 (R2021b) Update 1 was used for this study and coursework

These steps should be followed post going through the ReadMe_General.txt file

Random Forest - RFmodel.m

1. The below files should be present to run this script directly without running the dataprocessing scripts (loaddataandclean.m and consolidatetables.m)

load dataTestset.mat
load dataTrainset.mat
load modelingtablegdpsmote.mat
load undersampling.mat


2. run script RFmodel.m to generate output as 

Confusion Matrix

ROC Curve for majority class 'Growth'


3. The RF Base model could also be run for the SMOTE dataset and Undersampling datasets by amending lines 18-22 and 32-35 respectively





B. Full Model

treebaggerdec21final.m

C. Functions
mySMOTE.m
func1.m
CVlossfcn.m

D. Plots

the data selection plots section is commented out 



2. change directory , path to the copied location of the files 

from 

"C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\"
"C:\Users\aruna\OneDrive\Documents\GitH\ML CW\"



to 

<target path>