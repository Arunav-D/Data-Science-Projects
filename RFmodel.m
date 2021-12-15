%% E (i) Random Forest modelling base case

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
predictortrainvar=dataTrainset(:,[2:11]);
targettrainvar=dataTrainset(:,12);

%create the Training and Testing Datasets for Smote Dataset Model
%{
predictortrainvar=modelingtablegdpsmote(:,[1:10]);
targettrainvar=modelingtablegdpsmote(:,11);
%}

%aTest dataset constant for all scenarios
predictortestvar=dataTestset(:,[2:11]);
targettestvar=dataTestset(:,12);



%% E (i) using undersampling
%Train dataset with undersampling data
%{
predictortrainvar=undersampling(:,[1:10]);
targettrainvar=undersampling(:,11);
%}

%% E (ii) Train the Model

%y1=table2array(y);
%y2=categorical(y1);
%cp = cvpartition(y2,'k',10); %10-fold
XTRAIN=predictortrainvar;
ytrain=targettrainvar;
XTEST=predictortestvar;
ytest=targettestvar;
%% E (iii) Base Model Run 

MdlRFbase = TreeBagger(50,predictortrainvar,targettrainvar,'method','classification',...
    'OOBPredictorImportance','on','PredictorSelection','curvature');
    
%% E (iv) prediction for the Base Case Model

[predictgdpbase, scorebase] = predict(MdlRFbase,predictortestvar);
diffscorebase = scorebase(:,2) - max(scorebase(:,1));

predictgdpbase=categorical(predictgdpbase);
%targettestvar1=categorical(targettestvar);

% predictgdpc=table2array(predictgdp1);
targettestvarc=table2array(targettestvar);


%% E (v) Confusion Matrix for Base Case Model
%{
%}
%predictunders=renamecats(predictgdpbase,{'1','2'},{'decline','growth'});
Cmat = confusionmat(predictgdpbase,targettestvarc);
figure(1)
confusionchart(Cmat,{'GDP Decline','GDP Growth'});
title('Confusion Matrix for Random Forest')

%% E (vi) Growth Class Prediction accuracy
TPg = Cmat(2,2);
TNg = Cmat(1,1);
FPg = Cmat(1,2);
FNg = Cmat(2,1);

sensitivityg = TPg/(TPg + FNg)  %TPgR;
specificityg = TNg/(TNg + FPg)  %TNgR;
precisiong = TPg / (TPg + FPg);
FPRg = FPg/(TNg+FPg);
Accuracyg = (TPg+TNg)./(TPg+FPg+TNg+FNg);
recallg = TPg / (TPg + FNg);
F1 = (2 * precisiong * recallg) / (precisiong + recallg);
growthperf=[sensitivityg specificityg precisiong Accuracyg recallg F1 ]

%% E (vii) Decline Class Prediction accuracy
TPd = Cmat(1,1);
TNd = Cmat(2,2);
FPd = Cmat(2,1);
FNd = Cmat(1,2);

sensitivityd = TPd/(TPd + FNd)  %TPdR;
specificityd = TNd/(TNd + FPd)  %TNdR;
precisiond = TPd / (TPd + FPd);
FPRd = FPd/(TNd+FPd);
Accuracyd = (TPd+TNd)./(TPd+FPd+TNd+FNd);
recalld = TPd / (TPd + FNd);
F1 = (2 * precisiond * recalld) / (precisiond + recalld);
declineperf=[sensitivityd specificityd precisiond Accuracyd recalld F1 ]

%}
%%
%{
%}
targettestvarc=renamecats(targettestvarc,{'growth','decline'},{'2','1'});

%% 
[Xbase,Ybase,T,~,OPTROCPT,suby,subnames] = perfcurve(targettestvarc,diffscorebase,'2');
figure(2)
plot(Xbase,Ybase);
hold on;
plot(OPTROCPT(1),OPTROCPT(2),'ro');
xlabel('False positive rate') ;
ylabel('True positive rate');
title('ROC Curve for RandomForest TreeBaggerModel Base Case');
hold off;

%}