%% E (i) Naive Bayes modelling base case

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

predictortrainvar=dataTrainset(:,[2:12]);
targettrainvar=dataTrainset(:,12);

predictortestvar=dataTestset(:,[2:12]);
targettestvar=dataTestset(:,12);


%% E (ii) Train the Model

MdlNBbase = fitcnb(predictortrainvar,targettrainvar,'ClassNames',{'decline','growth'});

%% E (iii) Predict from the trained model
predictedgdpstatus = predict(MdlNBbase, predictortestvar);
temptruelab = table2array(targettestvar);
temptruelabtemp=categorical(temptruelab);
predictedgdpstatustemp=categorical(predictedgdpstatus);
checkresultsNBbase=[predictortestvar array2table(predictedgdpstatustemp)];
comparisonpredvactual = table(temptruelab,predictedgdpstatus,'VariableNames',...
    {'TrueLabel','PredictedLabel'});

%% E (iv) Confusion Matrix

cmnbmdlbase = confusionmat(temptruelabtemp,predictedgdpstatustemp);

confusionchart(cmnbmdlbase,{'GDP Decline', 'GDP Growth'});

%% E (vi) Growth Class Prediction accuracy

TPg = cmnbmdlbase(2,2);
TNg = cmnbmdlbase(1,1);
FPg = cmnbmdlbase(1,2);
FNg = cmnbmdlbase(2,1);

sensitivityg = TPg/(TPg + FNg)  %TPgR;
specificityg = TNg/(TNg + FPg)  %TNgR;
precisiong = TPg / (TPg + FPg);
FPRg = FPg/(TNg+FPg);
Accuracyg = (TPg+TNg)./(TPg+FPg+TNg+FNg);
recallg = TPg / (TPg + FNg);
F1 = (2 * precisiong * recallg) / (precisiong + recallg);
growthperf=[sensitivityg specificityg precisiong Accuracyg recallg F1 ]

%% E (vii) Decline Class Prediction accuracy
TPd = cmnbmdlbase(1,1);
TNd = cmnbmdlbase(2,2);
FPd = cmnbmdlbase(2,1);
FNd = cmnbmdlbase(1,2);

sensitivityd = TPd/(TPd + FNd)  %TPdR;
specificityd = TNd/(TNd + FPd)  %TNdR;
precisiond = TPd / (TPd + FPd);
FPRd = FPd/(TNd+FPd);
Accuracyd = (TPd+TNd)./(TPd+FPd+TNd+FNd);
recalld = TPd / (TPd + FNd);
F1 = (2 * precisiond * recalld) / (precisiond + recalld);
declineperf=[sensitivityd specificityd precisiond Accuracyd recalld F1 ]

%% crossvalidation results 
%{

CVMdlNBbase = crossval(cmnbmdlbase,'Holdout',0.3);
kfoldLoss(CVMdlNBbase);
label=kfoldPredict(CVMdlNBbase);


confusionchart_base=confusionchart(targettrainvar,label)
%}

%% E (viii) Train the Model post removal of highly correlated features
%{
idxnbase = fscmrmr(predictortrainvar,targettrainvar);
predictortrainvarnew = predictortrainvar(:,idxnb(1:3));
%}


%% E (viii) repeat the base model after removing correlated feature
% same steps for the base model except in this instance 

predictortrainvar=[];
targettrainvar=[];
predictortrainvar=dataTrainset(:,[2,6:12]);
targettrainvar=dataTrainset(:,12);


%aTest dataset constant for all scenarios
predictortestvar=dataTestset(:,[2,6:12]);
targettestvar=dataTestset(:,12);

%% Model re run with reduced predictor set

%% E (ii) Train the Model

MdlNBbasemod = fitcnb(predictortrainvar,targettrainvar,'ClassNames',{'decline','growth'});

%% E (iii) Predict from the trained model
predictedgdpstatus = predict(MdlNBbasemod, predictortestvar);
temptruelab = table2array(targettestvar);
temptruelabtemp=categorical(temptruelab);
predictedgdpstatustemp=categorical(predictedgdpstatus);
checkresultsNBMC=[predictortestvar array2table(predictedgdpstatustemp)];
comparisonpredvactual = table(temptruelab,predictedgdpstatus,'VariableNames',...
    {'TrueLabel','PredictedLabel'});

%% E (iv) Confusion Matrix

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

%% Cross fold Check
%{
t = templateNaiveBayes();
CVMdl2 = fitcecoc(X,Y,'CrossVal','on','Learners',t);
classErr1 = kfoldLoss(CVMdl1,'LossFun','ClassifErr')



classErr2 = kfoldLoss(CVMdl2,'LossFun','ClassifErr')

%}



