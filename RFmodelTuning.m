%% F (i) Random Forest modelling base case

clear all;
clc;
%load the Training and Test Sets created from Section D
load dataTestset.mat
load dataTrainset.mat
%load modelingtablegdpsmote.mat
%load undersampling.mat
%check size of Training and Test sets
size(dataTrainset);
size(dataTestset);

%create the Training and Testing Datasets for Base Model
predictortrainvar=dataTrainset(:,[2:12]);
targettrainvar=dataTrainset(:,12);


%aTest dataset constant for all scenarios
predictortestvar=dataTestset(:,[2:12]);
targettestvar=dataTestset(:,12);


%% F (ii) Train the Model

%y1=table2array(y);
%y2=categorical(y1);
%cp = cvpartition(y2,'k',10); %10-fold
XTRAIN=predictortrainvar;
ytrain=targettrainvar;
XTEST=predictortestvar;
ytest=targettestvar;

%% F (iii) Parameter Tuning
%{
%}

y1=table2array(ytest);
y2=categorical(y1);

%minLS=1;
%numPTS=88;
numTrees=[];
minLS=[];
numPTS=[];
hyperparametersRF=[];
numTrees =optimizableVariable('numTrees',[50,300],'Type','integer');
minLS = optimizableVariable('minLS',[20,40],'Type','integer');
numPTS = optimizableVariable('numPTS',[3,4],'Type','integer');
hyperparametersRF = [numTrees;minLS;numPTS];
cvp = cvpartition(y2,'k',10);
opts=statset('UseParallel',true);
%% F (iv) tuned for number of Trees, min Leaves and Num PTS hyperparameters
resultsmod = bayesopt(@(x)CVlossfcn(x,XTRAIN,ytrain,XTEST,ytest,cvp,opts),hyperparametersRF);


%missclassification error 
% missclasfError = crossval('mcr',XTRAIN,ytrain,'predfun',classA,'partition',cvp);


%% F (v) save use the hypertuned parameters from combination of Crossfold Bayesian Optimization

besthyperparametersCV = bestPoint(resultsmod);

%numTrees=besthyperparametersCV.numTrees;
minLS=besthyperparametersCV.minLS;
numPTS=besthyperparametersCV.numPTS;
numTrees=besthyperparametersCV.numTrees;

%{
%}

%% F (iv) Train model using best hyperparameters - NumTrees, LeafSize and PredictorToSample
%{
numTrees=163;
minLS=3;
numPTS=31;
predictortrainvarbest=dataTrainset(:,[2:12]);
targettrainvarbest=dataTrainset(:,[12]);

%% F (iv) create the best model based on the best tuned parameters

BestMdlRF = TreeBagger(numTrees,predictortrainvarbest,targettrainvarbest,'method','classification',...
    'OOBPredictorImportance','on','PredictorSelection','curvature',...
    'MinLeafSize',minLS,...
    'NumPredictorstoSample',numPTS);

%% Display the Tree structure
view(BestMdlRF.Trees{1},'Mode','graph');
%% Save Best Model 
save BestMdlRF BestMdlRF;

%% model performance
%% charts for model performance
% errorsmade = oobError(BestMdlprefCV,'Mode','Cumulative');

figure
plot(oobError(BestMdlRF));
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Classification Error');

%% model perfromance II

figure
plot(oobMeanMargin(BestMdlRF));
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Mean Classification Margin')

%% check feature importance for model
%{
figure
bar(BestMdlprefCV.OOBPermutedPredictorDeltaError);
xlabel('Feature Index');
ylabel('Out-of-Bag Feature Importance');

idxvar = find(BestMdlprefCV.OOBPermutedPredictorDeltaError>0.80)
%}

%% Model curvature test for Features

imp = BestMdlRF.OOBPermutedPredictorDeltaError;

figure;
bar(imp);
title('Curvature Test');
ylabel('Predictor importance estimates');
xlabel('Predictors');
h = gca;
% BestMdlprefCV.PredictorNames.Properties.VariableNames ={'M0Money','M1Money','M2Money','M3Money','M4FIMoney','M4NFIMoney','M4HouseholdMoney','M4InterMoney1','M4InterMoney2','InterestRate'};
h.XTickLabel = BestMdlRF.PredictorNames % ['M0Money','M1Money','M2Money','M3Money','M4FIMoney','M4NFIMoney','M4HouseholdMoney','M4InterMoney1','M4InterMoney2','InterestRate'];
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';





%% prediction with model performance check

[predictgdp, scoreCV] = predict(BestMdlRF,predictortestvar);
diffscoreCV = scoreCV(:,1) - max(scoreCV(:,2));


%%
predictgdp1=categorical(predictgdp);
%targettestvar1=categorical(targettestvar);

% predictgdpc=table2array(predictgdp1);
targettestvarc=table2array(targettestvar);

Cmatbest = confusionmat(predictgdp1,targettestvarc);

confusionchart(Cmatbest,{'GDP Growth','GDP Decline'});
%%
%% charts for model performance
% errorsmade = oobError(BestMdlRF,'Mode','Cumulative');

figure
plot(oobError(BestMdlRF));
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Classification Error');

%% model perfromance II

figure
plot(oobMeanMargin(BestMdlRF));
xlabel('Number of Grown Trees')
ylabel('Out-of-Bag Mean Classification Margin')

%% check feature importance for model
%{
figure
bar(BestMdlRF.OOBPermutedPredictorDeltaError);
xlabel('Feature Index');
ylabel('Out-of-Bag Feature Importance');

idxvar = find(BestMdlRF.OOBPermutedPredictorDeltaError>0.80)
%}

%% Model curvature test for Features

imp = BestMdlRF.OOBPermutedPredictorDeltaError;

figure;
bar(imp);
title('Curvature Test');
ylabel('Predictor importance estimates');
xlabel('Predictors');
h = gca;
% BestMdlRF.PredictorNames.Properties.VariableNames ={'M0Money','M1Money','M2Money','M3Money','M4FIMoney','M4NFIMoney','M4HouseholdMoney','M4InterMoney1','M4InterMoney2','InterestRate'};
h.XTickLabel = BestMdlRF.PredictorNames % ['M0Money','M1Money','M2Money','M3Money','M4FIMoney','M4NFIMoney','M4HouseholdMoney','M4InterMoney1','M4InterMoney2','InterestRate'];
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';




%%

%% ROC Curve for Treebagger Model 
%{
diffscoreCVmod = scoreCV(:,2) - scoreCV(:,1) ;

[X,Y,T,~,OPTROCPT,suby,subnames] = perfcurve(targettestvarc,diffscoreCVmod,'2');

plot(X,Y);
hold on;
plot(OPTROCPT(1),OPTROCPT(2),'ro');
xlabel('False positive rate') ;
ylabel('True positive rate');
title('ROC Curve for RandomForest TreeBaggerModel');
hold off;


%}

clear all;
clc;
%}
