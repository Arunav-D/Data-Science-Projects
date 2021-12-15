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


