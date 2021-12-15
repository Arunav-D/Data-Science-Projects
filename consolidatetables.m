%% B. Data Validation and Consolidation

%B1. Data Validation 

BankofEnglandDatabaseM0=readtable("BankofEnglandDatabaseM0.txt");
BankofEnglandDatabaseM0.Period = datetime(BankofEnglandDatabaseM0.Period,'Format','yyyy-MM','InputFormat','yyyy-MM');
BankofEnglandDatabaseM0.GrowthStatusM0=categorical(BankofEnglandDatabaseM0.GrowthStatusM0);

BankofEnglandDatabaseM1=readtable("BankofEnglandDatabaseM1.txt");
BankofEnglandDatabaseM1.Period = datetime(BankofEnglandDatabaseM1.Period,'Format','yyyy-MM','InputFormat','yyyy-MM');
BankofEnglandDatabaseM1.GrowthStatusM1=categorical(BankofEnglandDatabaseM1.GrowthStatusM1);

BankofEnglandDatabaseM2=readtable("BankofEnglandDatabaseM2.txt");
BankofEnglandDatabaseM2.Period = datetime(BankofEnglandDatabaseM2.Period,'Format','yyyy-MM','InputFormat','yyyy-MM');
BankofEnglandDatabaseM2.GrowthStatusM2=categorical(BankofEnglandDatabaseM2.GrowthStatusM2);

BankofEnglandDatabaseM3=readtable("BankofEnglandDatabaseM3.txt");
BankofEnglandDatabaseM3.Period = datetime(BankofEnglandDatabaseM3.Period,'Format','yyyy-MM','InputFormat','yyyy-MM');
BankofEnglandDatabaseM3.GrowthStatusM3=categorical(BankofEnglandDatabaseM3.GrowthStatusM3);

BankofEnglandDatabaseM4=readtable("BankofEnglandDatabaseM4.txt");
BankofEnglandDatabaseM4.Period = datetime(BankofEnglandDatabaseM4.Period,'Format','yyyy-MM','InputFormat','yyyy-MM');
BankofEnglandDatabaseM4.GrowthStatusM4=categorical(BankofEnglandDatabaseM4.GrowthStatusM4);

monthlygdp=readtable("monthlygdp.txt");
monthlygdp.Period = datetime(monthlygdp.Period,'Format','yyyy-MM','InputFormat','yyyy-MM');
monthlygdp.GrowthStatusGDP=categorical(monthlygdp.GrowthStatusGDP);
monthlygdp.GrowthStatusAgri=categorical(monthlygdp.GrowthStatusAgri);
monthlygdp.GrowthStatusProd=categorical(monthlygdp.GrowthStatusProd);
monthlygdp.GrowthStatusCons=categorical(monthlygdp.GrowthStatusCons);
monthlygdp.GrowthStatusServ=categorical(monthlygdp.GrowthStatusServ);


amendedBoERates=readtable("amendedBoERates.txt");
amendedBoERates.Period = datetime(amendedBoERates.Period,'Format','yyyy-MM','InputFormat','yyyy-MM');


%% B1 i. check for missing values
%{
ismissing('BankofEnglandDatabaseM0')
ismissing('BankofEnglandDatabaseM1')
ismissing('BankofEnglandDatabaseM2')
ismissing('BankofEnglandDatabaseM3')
ismissing('BankofEnglandDatabaseM4')
ismissing('monthlygdp')
ismissing('amendedBoERates')

%}

%% B2 ii boxplots

    subplot(3,3,1)
    boxplot(BankofEnglandDatabaseM0.NotesCoinsNotAdj);
    title('M0 Money');
    
    subplot(3,3,2)
    boxplot(BankofEnglandDatabaseM1.PrivatePublicSecLiabilities);
    title('M1 Money');
   
    subplot(3,3,3)
    boxplot(BankofEnglandDatabaseM2.LCYFCYPrivatePublicSecLiab);
    title('M2 Money');
        
    subplot(3,3,4)
    boxplot(BankofEnglandDatabaseM3.LCYFCYPrivatePublicSecLiab);
    title('M3 Money');
   
    subplot(3,3,5)
    boxplot(BankofEnglandDatabaseM4.TotalLiabPrivSec);
    title('M4 Money');
    
    subplot(3,3,6)
    boxplot(monthlygdp.MonthlyGDP);
    title('GDP');
    
%%


%B2. Condolidation of Money Supply, GDP and Interest Rate Tables

%% C. (i) sequential join of all the money measure tables M0, M1, M2, M3 and M4

M0M1=join(BankofEnglandDatabaseM0,BankofEnglandDatabaseM1,'Keys','Period');

M0M1M2=join(M0M1,BankofEnglandDatabaseM2,'Keys','Period');

M0M1M2M3=join(M0M1M2,BankofEnglandDatabaseM3,'Keys','Period');

M0ToM4=join(M0M1M2M3,BankofEnglandDatabaseM4,'Keys','Period');

%% C (ii) combining Money Supply with GDP

mergedM0M4astimetable = table2timetable(M0ToM4);
monthlygdpastimetable = table2timetable(monthlygdp);

M0ToM4new= removevars(mergedM0M4astimetable,{'GrowthStatusM0','GrowthStatusM1', 'GrowthStatusM2', 'GrowthStatusM3', 'GrowthStatusM4', 'GrowthStatusM4FI', 'GrowthStatusM4NFI', 'GrowthStatusM4Household'});

modM0M4 = retime(M0ToM4new,"regular","linear",...
    "TimeStep",calmonths(1));

monthlygdpnew = removevars(monthlygdpastimetable,{'GrowthStatusGDP', 'GrowthStatusAgri', 'GrowthStatusProd', 'GrowthStatusCons', 'GrowthStatusServ'});

modgdp = retime(monthlygdpnew,"regular","linear",...
    "TimeStep",calmonths(1));

% Synchronize timetables
combinedM0M4gdp = synchronize(modM0M4,modgdp,"commonrange",...
    "fillwithmissing");

%% c (iii) combined table join with Interest Rate

BoERatesTT = table2timetable(amendedBoERates);

BoERatesTTfilled = retime(BoERatesTT, 'monthly', 'previous');

combinedM0M4gdprates = synchronize(combinedM0M4gdp,BoERatesTTfilled,"commonrange",...
    "fillwithmissing");

%%

%% D. (i) Database selection for model 
modelingtablegdp = timetable2table(combinedM0M4gdprates);
modelingtablegdp.gdpgrowth = repmat("growth",height(modelingtablegdp),1);
modelingtablegdp.gdpgrowth(modelingtablegdp.GDPGrowthRate<0)="decline";
modelingtablegdp.gdpgrowth = categorical(modelingtablegdp.gdpgrowth);
save('modelingtablegdp.mat','modelingtablegdp');
writetable(modelingtablegdp);

%% D (ii) remove columns from consilidated dataset to prepare dataset for training and testing

deletecol = [{'M0Growth', 'M0GrowthRate', 'M1Growth', 'M1GrowthRate', 'M2Growth', 'M2GrowthRate', 'M3Growth', 'M3GrowthRate', 'M4Growth','M4GrowthRate', 'M4GrowthFIs', 'M4GrowthFIsRate', 'M4GrowthNFIs', 'M4GrowthNFIsRate', 'M4GrowthHousehold', 'M4GrowthHouseholdRate', 'GDPGrowth', 'GDPGrowthRate', 'AgriGrowth', 'AgriGrowthRate', 'ProdGrowth', 'ProdGrowthRate', 'ConsGrowth', 'ConsGrowthRate', 'ServGrowth', 'ServGrowthRate', 'TotalLiabPrivSec', 'LiabPrivNFIHousehold', 'MonthlyGDP','AgricultureSector','ProductionSector','ConstructionSector','ServiceSector'}];
modelingtablegdp(:, deletecol)=[];
%% D (iii) Rename columns and use for testing and training data

modelingtablegdp.Properties.VariableNames ={'Period'    'M0Money'    'M1Money'    'M2Money'    'M3Money' 'M4FIMoney'    'M4NFIMoney'    'M4HouseholdMoney' 'M4InterMoney1'  'M4InterMoney2'  'InterestRate'  'gdpgrowth'} ;
cvdataset = cvpartition(size(modelingtablegdp,1),'HoldOut',0.3);
idx = cvdataset.test;

dataTrainset = modelingtablegdp(~idx,:);
dataTestset  = modelingtablegdp(idx,:);

save('dataTrainset.mat','dataTrainset');
writetable(dataTrainset);
save('dataTestset.mat','dataTestset');
writetable(dataTestset);
%% D (iv) Dataset Class Label Balance Checks

dataTrainset.gdpgrowth=categorical(dataTrainset.gdpgrowth);
% check for class imbalance
subplot(2,1,1)
pie(dataTrainset.gdpgrowth);
title('Class Imbalance GDP Growth and Decline Labels - Trainingdata');
subplot(2,1,2)
pie(dataTestset.gdpgrowth);
title('Class Imbalance for GDP Growth and Decline Labels - Testdata')

%% D (iv) continued ....for outlier test and calculation of Descriptive Stats
outlier_test_preds=modelingtablegdp(:,2:11)
outlier_test_preds_results=isoutlier(outlier_test_preds);
desc_stats_mean=varfun(@(x)[mean(x);median(x);std(x);min(x);max(x)],outlier_test_preds);
desc_stats_mean.Properties.RowNames={'Mean' 'Median' 'StD' 'Min' 'Max'}
%% D (v) Smote for balancing Training Data

%{
%}

X=[];
C=[];

X=dataTrainset(:,[2:11]);
C= dataTrainset(:,12);
% rename categories for Smote
C=renamecats(C.gdpgrowth, {'growth','decline'},{'2','1'});
%% D (v) Smote for balancing Training Data


allDatatemp=[];
k=[];
allDatatemp=X;
k=20;
%IDX={'growth','decline'};
%sortedIDX=categorical(IDX);
[GN, ~, G] = unique(C);
%SIDX=G;
%G=categorical(G);
allData =allDatatemp(:,[1:10]);
allData.Category =G;
sortedIDX=sortrows(G);
X_smote = mySMOTE(allData, k,sortedIDX);
modelingtablegdpsmote=array2table(X_smote);
modelingtablegdpsmote.X_smote11=categorical(modelingtablegdpsmote.X_smote11);
modelingtablegdpsmote.Properties.VariableNames ={'M0Money','M1Money','M2Money','M3Money','M4FIMoney','M4NFIMoney','M4HouseholdMoney','M4InterMoney1','M4InterMoney2','InterestRate','GDP Growth'};
save('modelingtablegdpsmote.mat','modelingtablegdpsmote');
writetable(modelingtablegdpsmote);

%%
%{

subplot(2,1,1)
pie(modelingtablegdpsmote.("GDP Growth"));
title("post smote")
subplot(2,1,2)
Ctemp=table2array(C)
pie(Ctemp);
title("pre smote");

%}

%%
%{

corrplot(modelingtablegdp(:,2:11)%%


clear all;
clc;

%}


%% D (vi) Training Dataset with Undersampling 

% dataTrainset.gdpgrowth=renamecats(dataTrainset.gdpgrowth, {'growth','decline'},{'2','1'});
%X_RUS=RUS(dataTrainsetRUS, 2);

x = dataTrainset(:,2:12);
x.gdpgrowth=renamecats(x.gdpgrowth, {'growth','decline'},{'2','1'});
x.gdpgrowth=single(x.gdpgrowth);
xmod=table2array(x);
y = xmod(:,end);
%y=table2array(y);
%y=categorical(y);
%y=renamecats(y, {'growth','decline'},{'2','1'});

%%
%{
Samples_No=200;
X_RUS=RUS(xmod, Samples_No);
%}

%%
% Input an imbalanced data and number of samples
Samples_No=1;
r = xmod( find( y == 1 ), : );
t = xmod( find( y == 2 ), : );
if size(r,1) > size(t,1)
    p = floor((size(t,1))/1.25);
else
    p = floor((size(r,1))/1.25);
end
for i = 1 : Samples_No
    out1 = randperm(size(r,1),p);
    out1 = r(out1,:);
    out2 = randperm(size(t,1),p);
    out2 = t(out2,:);
    randSamp = [out1; out2];
    random_sample{i, :} = randSamp(randperm(size(randSamp, 1)), :); 
end

undersampling=array2table(randSamp);
undersampling.randSamp11=categorical(undersampling.randSamp11);
undersampling.Properties.VariableNames ={'M0Money','M1Money','M2Money','M3Money','M4FIMoney','M4NFIMoney','M4HouseholdMoney','M4InterMoney1','M4InterMoney2','InterestRate','GDP Growth'};
save('undersampling.mat','undersampling');
writetable(undersampling);
%% D (vi) Multicolinearity Analysis of Predictor features
corrplot(modelingtablegdp(:,2:11))

%%
clear all;
clc;
