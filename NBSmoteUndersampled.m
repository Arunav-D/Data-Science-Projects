
%% E (i) Random Forest modelling base case with SMOTE and Undersampling

clear all;
clc;
%load the Training and Test Sets created from Section D
load dataTestset.mat
load dataTrainset.mat
load modelingtablegdpsmote.mat
load undersampling.mat
%check size of Training and Test sets
size(dataTrainset);
size(dataTestset);

%create the Training and Testing Datasets for Base Model
%{
predictortrainvar=modelingtablegdpsmote(:,[1:11]);
targettrainvar=modelingtablegdpsmote(:,11);
%}

predictortrainvar=undersampling(:,[1:11]);
targettrainvar=undersampling(:,11);

predictortestvar=dataTestset(:,[2:12]);
targettestvar=dataTestset(:,12);

%%
MdlNBbasemod = fitcnb(predictortrainvar,targettrainvar,'ClassNames',{'1','2'});

%% E (iii) Predict from the trained model
predictedgdpstatus = predict(MdlNBbasemod, predictortestvar);
temptruelab = table2array(targettestvar);
temptruelabtemp=categorical(temptruelab);
predictedgdpstatustemp=categorical(predictedgdpstatus);
checkresultsNBMC=[predictortestvar array2table(predictedgdpstatustemp)];
comparisonpredvactual = table(temptruelab,predictedgdpstatus,'VariableNames',...
    {'TrueLabel','PredictedLabel'});

%% E (iv) Confusion Matrix
predictedgdpstatustemp=renamecats(predictedgdpstatustemp,{'1','2'},{'decline','growth'})
cmnbmdlbasemod = confusionmat(temptruelabtemp,predictedgdpstatustemp);

confusionchart(cmnbmdlbasemod,{'GDP Decline', 'GDP Growth'});

%% E (vi) Growth Class Prediction accuracy

TPg = cmnbmdlbasemod(2,2);
TNg = cmnbmdlbasemod(1,1);
FPg = cmnbmdlbasemod(1,2);
FNg = cmnbmdlbasemod(2,1);

sensitivityg = TPg/(TPg + FNg)  %TPgR;
specificityg = TNg/(TNg + FPg)  %TNgR;
precisiong = TPg / (TPg + FPg);
FPRg = FPg/(TNg+FPg);
Accuracyg = (TPg+TNg)./(TPg+FPg+TNg+FNg);
recallg = TPg / (TPg + FNg);
F1 = (2 * precisiong * recallg) / (precisiong + recallg);
growthperf=[sensitivityg specificityg precisiong Accuracyg recallg F1 ]

%% E (vii) Decline Class Prediction accuracy
TPd = cmnbmdlbasemod(1,1);
TNd = cmnbmdlbasemod(2,2);
FPd = cmnbmdlbasemod(2,1);
FNd = cmnbmdlbasemod(1,2);

sensitivityd = TPd/(TPd + FNd)  %TPdR;
specificityd = TNd/(TNd + FPd)  %TNdR;
precisiond = TPd / (TPd + FPd);
FPRd = FPd/(TNd+FPd);
Accuracyd = (TPd+TNd)./(TPd+FPd+TNd+FNd);
recalld = TPd / (TPd + FNd);
F1 = (2 * precisiond * recalld) / (precisiond + recalld);
declineperf=[sensitivityd specificityd precisiond Accuracyd recalld F1 ]

%% e (viii) ROC 

