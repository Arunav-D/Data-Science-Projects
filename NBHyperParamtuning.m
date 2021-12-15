%% F (i) Naive Bayes modelling base case
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
predictortrainvar=dataTrainset(:,[2:12]);
targettrainvar=dataTrainset(:,12);

predictortestvar=dataTestset(:,[2:12]);
targettestvar=dataTestset(:,12);
%}

%% f (i) using dimensionally reduced model 

predictortrainvar=[];
targettrainvar=[];
%% using undersampling 
predictortrainvar=undersampling(:,[1,5:11]);
predictortrainvar
targettrainvar=undersampling(:,11);
%targettrainvar=table2array(targettrainvar);
%targettrainvar=renamecats(targettrainvar,{'1','2'},{'decline','growth'});
%targettrainvar=array2table(targettrainvar);

%aTest dataset constant for all scenarios
predictortestvar=dataTestset(:,[2,6:12]);
targettestvar=dataTestset(:,12);

%% f (ii) NB Hyperparament Tuning

%classNames={'decline','growth'};
classNames={'1','2'} % changed for undersampling tuning 
rng default
Mdlhpt = fitcnb(predictortrainvar,targettrainvar,'ClassNames',classNames,...
    'OptimizeHyperparameters',{'DistributionNames','kernel'},...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus',...
    'Optimizer', 'bayesopt',...
    'KFold',20, ...
    'Verbose',2));

%% plot of convergence post tuning 
resultsnbtuned = Mdlhpt.HyperparameterOptimizationResults
plot(resultsnbtuned.ObjectiveMinimumTrace,'Marker','o','MarkerSize',5);
legend('Naive Bayes','Location','northeast')
title('Bayesian Optimization')
xlabel('Number of Iterations')
ylabel('Minimum Objective Value')

%% f (iii) NB Predictions from the Model
Mdlhpt.Prior=[.40 .60];
[labelsnbpt,scorenb] = predict(Mdlhpt,predictortestvar);

% predictedgdpstatus = predict((Mdlhpt, predictortestvar);

nbtemptruelabhpt=categorical(labelsnbpt);
temptarvar = table2array(targettestvar);
%%  f (iv) confusion Matrix 
nbtemptruelabhpt=renamecats(nbtemptruelabhpt,{'1','2'},{'decline','growth'}) % added for undersampled tuning
Cmatnbhpt = confusionmat(temptarvar,nbtemptruelabhpt);

confusionchart(Cmatnbhpt,{'GDP Decline','GDP Growth'});
%confusionchart((temptarvar,nbtemptruelabtemp),{'GDP Growth','GDP Decline'})

%% f (v) Model performance Score measures 

TPg = Cmatnbhpt(2,2);
TNg = Cmatnbhpt(1,1);
FPg = Cmatnbhpt(1,2);
FNg = Cmatnbhpt(2,1);

sensitivityg = TPg/(TPg + FNg)  %TPgR;
specificityg = TNg/(TNg + FPg)  %TNgR;
precisiong = TPg / (TPg + FPg);
FPRg = FPg/(TNg+FPg);
Accuracyg = (TPg+TNg)./(TPg+FPg+TNg+FNg);
recallg = TPg / (TPg + FNg);
F1 = (2 * precisiong * recallg) / (precisiong + recallg);
growthperf=[sensitivityg specificityg precisiong Accuracyg recallg F1 ]

%% E (vii) Decline Class Prediction accuracy
TPd = Cmatnbhpt(1,1);
TNd = Cmatnbhpt(2,2);
FPd = Cmatnbhpt(2,1);
FNd = Cmatnbhpt(1,2);

sensitivityd = TPd/(TPd + FNd)  %TPdR;
specificityd = TNd/(TNd + FPd)  %TNdR;
precisiond = TPd / (TPd + FPd);
FPRd = FPd/(TNd+FPd);
Accuracyd = (TPd+TNd)./(TPd+FPd+TNd+FNd);
recalld = TPd / (TPd + FNd);
F1 = (2 * precisiond * recalld) / (precisiond + recalld);
declineperf=[sensitivityd specificityd precisiond Accuracyd recalld F1 ]



%% E (vi) Growth Class Prediction accuracy
%% ROC
%{
diffscorenb = scorenb(:,2) - scorenb(:,1)
[Xnb,Ynb,~,AUCnb] = perfcurve(temptarvar,diffscorenb,'2');
plot(Xnb,Ynb);

title('ROC Curves')
xlabel('False Positive Rate')
ylabel('True Positive Rate')
legend('NAive Bayes','Location','southeast')
%}
