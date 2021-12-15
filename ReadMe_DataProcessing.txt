MAtlab - 9.11.0.1809720 (R2021b) Update 1 was used for this study and coursework

These steps should be followed post going through the ReadMe_General.txt file

The below steps should be used to upload the datasets, cleanup, dataset analysis and creation of the consolidated dataset for Training and Testing of Model.
Results from these steps would be used for both Random Forest and Naive Bayes Modelling. They can be run in sequence or part B could be run independently 
by extracting the relevant files created from section A and attached in the zip file

Section A. Data Loading, formatting and initial assessments 

1. Extract the attached file from the zip folder into the chosen directory <PATH>

BankofEnglandDatabaseM0.xlsx
BankofEnglandDatabaseM1.xlsx
BankofEnglandDatabaseM2.xlsx
BankofEnglandDatabaseM3.xlsx
BankofEnglandDatabaseM4.xlsx
monthlygdpto4dpsep20211.xlsx
BankRatehistoryBoE.xlsx
mySMOTE.m

2. in loaddataandclean.m , set "C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\" to <PATH> as per location of the source files (step1)

code lines - 37, 86, 134, 183, 233, 347, 503

3. Run the script loaddataandclean.m to generate output as 

BankofEnglandDatabaseM0.mat and .txt
BankofEnglandDatabaseM1.mat and .txt
BankofEnglandDatabaseM2.mat and .txt
BankofEnglandDatabaseM2.mat and .txt
BankofEnglandDatabaseM3.mat and .txt
BankofEnglandDatabaseM4.mat and .txt
monthlygdp.mat and .txt
amendedBoERates.mat and .txt


Section B. Data Consolidation - Merging of individual files into a consolidated table in preparation for modelling. This step could be performed independently from Section A
provided the relevant files are extracted from the zip file into the appropriate <PATH>

1. To run this script directly without running loaddataandclean.m, extract files - BankofEnglandDatabaseM0.txt, BankofEnglandDatabaseM1.txt, BankofEnglandDatabaseM2.txt, 
BankofEnglandDatabaseM3.txt, BankofEnglandDatabaseM4.txt, monthlygdp.txt, amendedBoERates, mySMOTE.m

2. run script consolidatetables.m to generate output as 

a. charts for data analysis - including box plots, class imbalance pie charts, multicolinearty analysis
b. descriptive statsticial analysis - outliers, mean, median, standard deviation, max and min for the Predictor features
c. Consolidated output files for creating Training and Test sets for models as

dataTrainset.mat (for baseline model)
dataTestset.mat (for all testing)
modelingtablegdpsmote.mat (for modeling to assess impact from SMOTE)
undersampling.mat (for modelling to assess impact from undersampling)

modelingtablegdp.mat (consolidated table used for creating Training and Test Sets)
