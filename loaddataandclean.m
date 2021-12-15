%% A. Data Upload - Import Source data from separate and multiple files
% A1. contains script for uploading Money Supply Data M0, M1, M2, M4 and M4
% A2. contains script for uploading GDP Data
% A3. contains script for uploading Interest Rate Data
%% A1 upload of Money Supply Data
% 
% Import data from BoE spreadsheets for M0, M1, M2, M3 and M4 Money Measures
% Script for importing data from the following spreadsheet:
% M0 - https://www.bankofengland.co.uk/statistics/details/further-details-about-m0-data
% M1 - https://www.bankofengland.co.uk/boeapps/database/fromshowcolumns.asp?ShowData.x=40&ShowData.y=45&Travel=NIxAZx&ShadowPage=1&FromCategoryList=Yes&CategID=6&NewMeaningId=LM1EMU&HighlightCatValueDisplay=M1&ActualResNumPerPage=&TotalNumResults=8&XNotes2=Y&C=1E6
% M2 - https://www.bankofengland.co.uk/boeapps/database/FromShowColumns.asp?Travel=NIxAZxI3x&FromCategoryList=Yes&NewMeaningId=LM2EMU&CategId=6&HighlightCatValueDisplay=M2%20%20(estimate%20of%20EMU%20aggregate%20for%20the%20UK)
% M3 - https://www.bankofengland.co.uk/boeapps/database/FromShowColumns.asp?Travel=NIxAZxI1x&FromCategoryList=Yes&NewMeaningId=LM3EMU&CategId=6&HighlightCatValueDisplay=M3%20%20(estimate%20of%20EMU%20aggregate%20for%20the%20UK)
% M4 - https://www.bankofengland.co.uk/boeapps/database/fromshowcolumns.asp?ShowData.x=114&ShowData.y=33&Travel=NIxAZx&ShadowPage=1&FromCategoryList=Yes&CategID=6&NewMeaningId=LM4L%2CLM4&HighlightCatValueDisplay=M4&ActualResNumPerPage=151X&TotalNumResults=164&XNotes2=Y&C=61C&C=MCN&C=H8&C=5Q8&C=5Q9&C=M13&C=M0Q

% all files dowloaded from listed websites and saved in the below directory
%    Workbook: C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\
%    Worksheet: Sheet1

clear all;
clc;
%% A1 - (i) Load M0 File , calculate Month on Month Growth/Decline Rate, Assign Growth/Decline labels
opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:C288";

% Specify column names and types
opts.VariableNames = ["Date", "MonthlyAverageAmountOutstandingOfTotalSterlingNotesAndCoinInCir"];
opts.VariableTypes = ["string", "double"];

% Specify variable properties
opts = setvaropts(opts, "Date", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Date", "EmptyFieldRule", "auto");

% Importing the M0 data into table and renaming the columns
BankofEnglandDatabaseM0 = readtable("C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\BankofEnglandDatabaseM0.xlsx", opts, "UseExcel", false);
BankofEnglandDatabaseM0.Date = datetime(BankofEnglandDatabaseM0.Date,'Format','yyyy-MM','InputFormat','dd MMM yy') ;
BankofEnglandDatabaseM0.Properties.VariableNames = {'Period' 'NotesCoinsNotAdj'} ;

BankofEnglandDatabaseM0(end,:) = [];

GrowthM0 = -(diff(BankofEnglandDatabaseM0.NotesCoinsNotAdj)); 
M0Growth= array2table(GrowthM0,'VariableNames',{'M0Growth'});

GrowthrateM0=-(diff(BankofEnglandDatabaseM0.NotesCoinsNotAdj)./BankofEnglandDatabaseM0.NotesCoinsNotAdj(1:end-1,:))*100;
M0Growthrate=array2table(GrowthrateM0,'VariableNames',{'M0GrowthRate'});

BankofEnglandDatabaseM0(end,:)=[];

BankofEnglandDatabaseM0 = [BankofEnglandDatabaseM0 M0Growth M0Growthrate];
for i = 1:height(BankofEnglandDatabaseM0)
    if BankofEnglandDatabaseM0.M0GrowthRate(i) < 0
        StatusM0{i} ='Decline';
       
    else
        StatusM0{i} ='Growth';
    end

end

StatusM0 = StatusM0';
GrowthStatusM0 = array2table(StatusM0,'VariableNames',{'GrowthStatusM0'});
BankofEnglandDatabaseM0 = [BankofEnglandDatabaseM0 GrowthStatusM0];
BankofEnglandDatabaseM0.GrowthStatusM0 = categorical(BankofEnglandDatabaseM0.GrowthStatusM0);
save('BankofEnglandDatabaseM0.mat','BankofEnglandDatabaseM0');
writetable(BankofEnglandDatabaseM0);
clear all;
clc;
%% A1 - (ii) Load M1 File , calculate Month on Month Growth/Decline Rate, Assign Growth/Decline labels
opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:B288";

% Specify column names and types
opts.VariableNames = ["Date", "MonthlyAmountsOutstandingOfMonetaryFinancialInstitutionsSterlin"];
opts.VariableTypes = ["string", "double"];

% Specify variable properties
opts = setvaropts(opts, "Date", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Date", "EmptyFieldRule", "auto");

% Import the data
BankofEnglandDatabaseM1 = readtable("C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\BankofEnglandDatabaseM1.xlsx", opts, "UseExcel", false);
BankofEnglandDatabaseM1.Date = datetime(BankofEnglandDatabaseM1.Date,'Format','yyyy-MM','InputFormat','dd MMM yy') ;
BankofEnglandDatabaseM1.Properties.VariableNames = {'Period' 'PrivatePublicSecLiabilities'} ;

GrowthM1 = -(diff(BankofEnglandDatabaseM1.PrivatePublicSecLiabilities)); 
M1Growth= array2table(GrowthM1,'VariableNames',{'M1Growth'});

GrowthrateM1=-(diff(BankofEnglandDatabaseM1.PrivatePublicSecLiabilities)./BankofEnglandDatabaseM1.PrivatePublicSecLiabilities(1:end-1,:))*100;
M1Growthrate=array2table(GrowthrateM1,'VariableNames',{'M1GrowthRate'});

BankofEnglandDatabaseM1(end,:)=[];

BankofEnglandDatabaseM1 = [BankofEnglandDatabaseM1 M1Growth M1Growthrate];
for i = 1:height(BankofEnglandDatabaseM1)
    if BankofEnglandDatabaseM1.M1GrowthRate(i) < 0
        StatusM1{i} ='Decline';
       
    else
        StatusM1{i} ='Growth';
    end

end

StatusM1 = StatusM1';
GrowthStatusM1 = array2table(StatusM1,'VariableNames',{'GrowthStatusM1'});
BankofEnglandDatabaseM1 = [BankofEnglandDatabaseM1 GrowthStatusM1];
BankofEnglandDatabaseM1.GrowthStatusM1 = categorical(BankofEnglandDatabaseM1.GrowthStatusM1);
save('BankofEnglandDatabaseM1.mat','BankofEnglandDatabaseM1');
writetable(BankofEnglandDatabaseM1);
clear all;
clc;
%% A1 - (iii) Load M2 File , calculate Month on Month Growth/Decline Rate, Assign Growth/Decline labels
clear opts
opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:B288";

% Specify column names and types
opts.VariableNames = ["Date", "MonthlyAmountsOutstandingOfMonetaryFinancialInstitutionsSterlin"];
opts.VariableTypes = ["string", "double"];

% Specify variable properties
opts = setvaropts(opts, "Date", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Date", "EmptyFieldRule", "auto");

% Import the data
BankofEnglandDatabaseM2 = readtable("C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\BankofEnglandDatabaseM2.xlsx", opts, "UseExcel", false);
BankofEnglandDatabaseM2.Date = datetime(BankofEnglandDatabaseM2.Date,'Format','yyyy-MM','InputFormat','dd MMM yy') ;
BankofEnglandDatabaseM2.Properties.VariableNames = {'Period' 'LCYFCYPrivatePublicSecLiab'} ;

GrowthM2 = -(diff(BankofEnglandDatabaseM2.LCYFCYPrivatePublicSecLiab)); 
M2Growth= array2table(GrowthM2,'VariableNames',{'M2Growth'});

GrowthrateM2=-(diff(BankofEnglandDatabaseM2.LCYFCYPrivatePublicSecLiab)./BankofEnglandDatabaseM2.LCYFCYPrivatePublicSecLiab(1:end-1,:))*100;
M2Growthrate=array2table(GrowthrateM2,'VariableNames',{'M2GrowthRate'});

BankofEnglandDatabaseM2(end,:)=[];

BankofEnglandDatabaseM2 = [BankofEnglandDatabaseM2 M2Growth M2Growthrate];
for i = 1:height(BankofEnglandDatabaseM2)
    if BankofEnglandDatabaseM2.M2GrowthRate(i) < 0
        StatusM2{i} ='Decline';
       
    else
        StatusM2{i} ='Growth';
    end

end

StatusM2 = StatusM2';
GrowthStatusM2 = array2table(StatusM2,'VariableNames',{'GrowthStatusM2'});
BankofEnglandDatabaseM2 = [BankofEnglandDatabaseM2 GrowthStatusM2];
BankofEnglandDatabaseM2.GrowthStatusM2 = categorical(BankofEnglandDatabaseM2.GrowthStatusM2);
save('BankofEnglandDatabaseM2.mat','BankofEnglandDatabaseM2');
writetable(BankofEnglandDatabaseM2);
clear all;
clc;
%% A1 - (iv) Load M3 File , calculate Month on Month Growth/Decline Rate, Assign Growth/Decline labels
clear opts;

opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:B288";

% Specify column names and types
opts.VariableNames = ["Date", "MonthlyAmountsOutstandingOfMonetaryFinancialInstitutionsSterlin"];
opts.VariableTypes = ["string", "double"];

% Specify variable properties
opts = setvaropts(opts, "Date", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Date", "EmptyFieldRule", "auto");

% Import the data
BankofEnglandDatabaseM3 = readtable("C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\BankofEnglandDatabaseM3.xlsx", opts, "UseExcel", false);
BankofEnglandDatabaseM3.Date = datetime(BankofEnglandDatabaseM3.Date,'Format','yyyy-MM','InputFormat','dd MMM yy') ;
BankofEnglandDatabaseM3.Properties.VariableNames = {'Period' 'LCYFCYPrivatePublicSecLiab'} ;

GrowthM3 = -(diff(BankofEnglandDatabaseM3.LCYFCYPrivatePublicSecLiab)); 
M3Growth= array2table(GrowthM3,'VariableNames',{'M3Growth'});

GrowthrateM3=-(diff(BankofEnglandDatabaseM3.LCYFCYPrivatePublicSecLiab)./BankofEnglandDatabaseM3.LCYFCYPrivatePublicSecLiab(1:end-1,:))*100;
M3Growthrate=array2table(GrowthrateM3,'VariableNames',{'M3GrowthRate'});

BankofEnglandDatabaseM3(end,:)=[];

BankofEnglandDatabaseM3 = [BankofEnglandDatabaseM3 M3Growth M3Growthrate];
for i = 1:height(BankofEnglandDatabaseM3)
    if BankofEnglandDatabaseM3.M3GrowthRate(i) < 0
        StatusM3{i} ='Decline';
       
    else
        StatusM3{i} ='Growth';
    end

end

StatusM3 = StatusM3';
GrowthStatusM3 = array2table(StatusM3,'VariableNames',{'GrowthStatusM3'});
BankofEnglandDatabaseM3 = [BankofEnglandDatabaseM3 GrowthStatusM3];
BankofEnglandDatabaseM3.GrowthStatusM3 = categorical(BankofEnglandDatabaseM3.GrowthStatusM3);
save('BankofEnglandDatabaseM3.mat','BankofEnglandDatabaseM3');
writetable(BankofEnglandDatabaseM3);
clear all;
clc;
%% A1 - (v) Load M4 File , calculate Month on Month Growth/Decline Rate, Assign Growth/Decline labels

clear opts;

opts = spreadsheetImportOptions("NumVariables", 8);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:H288";

% Specify column names and types
opts.VariableNames = ["Date", "MonthlyAmountsOutstandingOfM4monetaryFinancialInstitutionsSterl", "MonthlyAmountsOutstandingOfMonetaryFinancialInstitutionsSterlin", "MonthlyAmountsOutstandingOfMonetaryFinancialInstitutionsSterli1", "MonthlyAmountsOutstandingOfMonetaryFinancialInstitutionsSterli2", "MonthlyAmountsOutstandingOfMonetaryFinancialInstitutionsSterli3", "MonthlyAmountsOutstandingOfUKResidentMonetaryFinancialInstituti", "MonthlyAmountsOutstandingOfUKResidentMonetaryFinancialInstitut1"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, "Date", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Date", "EmptyFieldRule", "auto");

% Import the data
BankofEnglandDatabaseM4 = readtable("C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\BankofEnglandDatabaseM4.xlsx", opts, "UseExcel", false);
BankofEnglandDatabaseM4.Date = datetime(BankofEnglandDatabaseM4.Date,'Format','yyyy-MM','InputFormat','dd MMM yy') ;
BankofEnglandDatabaseM4.Properties.VariableNames = {'Period' 'TotalLiabPrivSec' 'LiabPrivNFIHousehold' 'LiabPrivFIs'  'LiabPrivNFIs' 'LiabPrivHousehold' 'PrivexcldOFCs' 'PrivOFCsexcldIntOFCs'};

GrowthM4 = -(diff(BankofEnglandDatabaseM4.TotalLiabPrivSec)); 
M4Growth= array2table(GrowthM4,'VariableNames',{'M4Growth'});

GrowthrateM4=-(diff(BankofEnglandDatabaseM4.TotalLiabPrivSec)./BankofEnglandDatabaseM4.TotalLiabPrivSec(1:end-1,:))*100;
M4Growthrate=array2table(GrowthrateM4,'VariableNames',{'M4GrowthRate'});

GrowthM4FIs = -(diff(BankofEnglandDatabaseM4.LiabPrivFIs)); 
M4GrowthFIs= array2table(GrowthM4FIs,'VariableNames',{'M4GrowthFIs'});

GrowthrateM4FIs=-(diff(BankofEnglandDatabaseM4.LiabPrivFIs)./BankofEnglandDatabaseM4.LiabPrivFIs(1:end-1,:))*100;
M4GrowthFIsrate=array2table(GrowthrateM4FIs,'VariableNames',{'M4GrowthFIsRate'});

GrowthM4NFIs = -(diff(BankofEnglandDatabaseM4.LiabPrivNFIs)); 
M4GrowthNFIs= array2table(GrowthM4NFIs,'VariableNames',{'M4GrowthNFIs'});

GrowthrateM4NFIs=-(diff(BankofEnglandDatabaseM4.LiabPrivNFIs)./BankofEnglandDatabaseM4.LiabPrivNFIs(1:end-1,:))*100;
M4GrowthNFIsrate=array2table(GrowthrateM4NFIs,'VariableNames',{'M4GrowthNFIsRate'});

GrowthM4Household = -(diff(BankofEnglandDatabaseM4.LiabPrivHousehold)); 
M4GrowthHousehold= array2table(GrowthM4Household,'VariableNames',{'M4GrowthHousehold'});

GrowthrateM4Household=-(diff(BankofEnglandDatabaseM4.LiabPrivHousehold)./BankofEnglandDatabaseM4.LiabPrivHousehold(1:end-1,:))*100;
M4GrowthHouseholdrate=array2table(GrowthrateM4Household,'VariableNames',{'M4GrowthHouseholdRate'});

BankofEnglandDatabaseM4(end,:)=[];

BankofEnglandDatabaseM4 = [BankofEnglandDatabaseM4 M4Growth M4Growthrate];
for i = 1:height(BankofEnglandDatabaseM4)
    if BankofEnglandDatabaseM4.M4GrowthRate(i) < 0
        StatusM4{i} ='Decline';
       
    else
        StatusM4{i} ='Growth';
    end

end

StatusM4 = StatusM4';
GrowthStatusM4 = array2table(StatusM4,'VariableNames',{'GrowthStatusM4'});
BankofEnglandDatabaseM4 = [BankofEnglandDatabaseM4 GrowthStatusM4];
BankofEnglandDatabaseM4.GrowthStatusM4 = categorical(BankofEnglandDatabaseM4.GrowthStatusM4);
BankofEnglandDatabaseM4 = [BankofEnglandDatabaseM4 M4GrowthFIs M4GrowthFIsrate];
for i = 1:height(BankofEnglandDatabaseM4)
    if BankofEnglandDatabaseM4.M4GrowthFIsRate(i) < 0
        StatusM4FI{i} ='Decline';
       
    else
        StatusM4FI{i} ='Growth';
    end

end

StatusM4FI = StatusM4FI';
GrowthStatusM4FI = array2table(StatusM4FI,'VariableNames',{'GrowthStatusM4FI'});
BankofEnglandDatabaseM4 = [BankofEnglandDatabaseM4 GrowthStatusM4FI];
BankofEnglandDatabaseM4.GrowthStatusM4FI = categorical(BankofEnglandDatabaseM4.GrowthStatusM4FI);
BankofEnglandDatabaseM4 = [BankofEnglandDatabaseM4 M4GrowthNFIs M4GrowthNFIsrate];

for i = 1:height(BankofEnglandDatabaseM4)
    if BankofEnglandDatabaseM4.M4GrowthNFIsRate(i) < 0
        StatusM4NFI{i} ='Decline';
       
    else
        StatusM4NFI{i} ='Growth';
    end

end

StatusM4NFI = StatusM4NFI';
GrowthStatusM4NFI = array2table(StatusM4NFI,'VariableNames',{'GrowthStatusM4NFI'});
BankofEnglandDatabaseM4 = [BankofEnglandDatabaseM4 GrowthStatusM4NFI];
BankofEnglandDatabaseM4.GrowthStatusM4NFI = categorical(BankofEnglandDatabaseM4.GrowthStatusM4NFI);
BankofEnglandDatabaseM4 = [BankofEnglandDatabaseM4 M4GrowthHousehold M4GrowthHouseholdrate];

for i = 1:height(BankofEnglandDatabaseM4)
    if BankofEnglandDatabaseM4.M4GrowthHouseholdRate(i) < 0
        StatusM4Household{i} ='Decline';
       
    else
        StatusM4Household{i} ='Growth';
    end

end

StatusM4Household = StatusM4Household';
GrowthStatusM4Household = array2table(StatusM4Household,'VariableNames',{'GrowthStatusM4Household'});
BankofEnglandDatabaseM4 = [BankofEnglandDatabaseM4 GrowthStatusM4Household];
BankofEnglandDatabaseM4.GrowthStatusM4Household = categorical(BankofEnglandDatabaseM4.GrowthStatusM4Household);
save('BankofEnglandDatabaseM4.mat','BankofEnglandDatabaseM4');
writetable(BankofEnglandDatabaseM4);
clear all;
clc;
%% A2 - upload GDP data file, calculating Month on Month Growth/Decline Rate for Monthly GDP as well as Sectors, Assigning Labels - Growth/Decline to Monthly GDP and Sectors based on postive/negative growth rates
% source - https://www.ons.gov.uk/economy/grossdomesticproductgdp/datasets/monthlygdpandmainsectorstofourdecimalplaces
% Monthly index values for monthly gross domestic product (GDP) and the main sectors in the UK to four decimal places.
opts = spreadsheetImportOptions("NumVariables", 6);

% Specify sheet and range
opts.Sheet = "Data_table";
opts.DataRange = "A5:F301";

% Specify column names and types
opts.VariableNames = ["Month", "MonthlyGDPAT", "AgricultureA", "ProductionBE", "ConstructionFnote1note2", "ServicesGT"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, "Month", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Month", "EmptyFieldRule", "auto");

% Import the data
monthlygdptemp = readtable("C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\monthlygdpto4dpsep20211.xlsx", opts, "UseExcel", false);
monthlygdptemp.Month = datetime(monthlygdptemp.Month,'Format','yyyy-MM','InputFormat','yyyyMMM');
monthlygdptemp.Properties.VariableNames = {'Period' 'MonthlyGDP' 'AgricultureSector' 'ProductionSector' 'ConstructionSector' 'ServiceSector'};
monthlygdp = sortrows(monthlygdptemp,1,'descend');

% Growth Rate calculation for GDP
GrowthGDP = -diff(monthlygdp.MonthlyGDP); 
GDPGrowth= array2table(GrowthGDP,'VariableNames',{'GDPGrowth'});
GrowthrateGDP= -diff(monthlygdp.MonthlyGDP)./monthlygdp.MonthlyGDP(1:end-1,:)*100;
GDPGrowthrate=array2table(GrowthrateGDP,'VariableNames',{'GDPGrowthRate'});

% growth rate for agriculature sector
GrowthAgri = -diff(monthlygdp.AgricultureSector); 
AgriGrowth= array2table(GrowthAgri,'VariableNames',{'AgriGrowth'});
GrowthrateAgri= -diff(monthlygdp.AgricultureSector)./monthlygdp.AgricultureSector(1:end-1,:)*100;
AgriGrowthrate=array2table(GrowthrateAgri,'VariableNames',{'AgriGrowthRate'});


% growth rate for Production sector
GrowthProd = -diff(monthlygdp.ProductionSector); 
ProdGrowth= array2table(GrowthProd,'VariableNames',{'ProdGrowth'});
GrowthrateProd= -diff(monthlygdp.ProductionSector)./monthlygdp.ProductionSector(1:end-1,:)*100;
ProdGrowthrate=array2table(GrowthrateProd,'VariableNames',{'ProdGrowthRate'});

% growth rate for Construction sector
GrowthCons = -diff(monthlygdp.ConstructionSector); 
ConsGrowth= array2table(GrowthCons,'VariableNames',{'ConsGrowth'});
GrowthrateCons= -diff(monthlygdp.ConstructionSector)./monthlygdp.ConstructionSector(1:end-1,:)*100;
ConsGrowthrate=array2table(GrowthrateCons,'VariableNames',{'ConsGrowthRate'});

% growth rate of Service sector
GrowthServ = -diff(monthlygdp.ServiceSector); 
ServGrowth= array2table(GrowthServ,'VariableNames',{'ServGrowth'});
GrowthrateServ= -diff(monthlygdp.ServiceSector)./monthlygdp.ServiceSector(1:end-1,:)*100;
ServGrowthrate=array2table(GrowthrateServ,'VariableNames',{'ServGrowthRate'});

monthlygdp(end,:)=[];
monthlygdp = [monthlygdp GDPGrowth GDPGrowthrate];
for i = 1:height(monthlygdp)
    if monthlygdp.GDPGrowthRate(i) < 0
        StatusGDP{i} ='Decline';
       
    else
        StatusGDP{i} ='Growth';
    end

end

StatusGDP = StatusGDP';
GrowthStatusGDP = array2table(StatusGDP,'VariableNames',{'GrowthStatusGDP'});
monthlygdp = [monthlygdp GrowthStatusGDP];
monthlygdp.GrowthStatusGDP = categorical(monthlygdp.GrowthStatusGDP);

% monthlygdp(end,:)=[];

monthlygdp = [monthlygdp AgriGrowth AgriGrowthrate];

for i = 1:height(monthlygdp)
    if monthlygdp.AgriGrowthRate(i) < 0
        StatusAgri{i} ='Decline';
       
    else
        StatusAgri{i} ='Growth';
    end

end

StatusAgri = StatusAgri';
GrowthStatusAgri = array2table(StatusAgri,'VariableNames',{'GrowthStatusAgri'});
monthlygdp = [monthlygdp GrowthStatusAgri];
monthlygdp.GrowthStatusAgri = categorical(monthlygdp.GrowthStatusAgri);

% monthlygdp(end,:)=[];

monthlygdp = [monthlygdp ProdGrowth ProdGrowthrate];

for i = 1:height(monthlygdp)
    if monthlygdp.ProdGrowthRate(i) < 0
        StatusProd{i} ='Decline';
       
    else
        StatusProd{i} ='Growth';
    end

end

StatusProd = StatusProd';
GrowthStatusProd = array2table(StatusProd,'VariableNames',{'GrowthStatusProd'});
monthlygdp = [monthlygdp GrowthStatusProd];
monthlygdp.GrowthStatusProd = categorical(monthlygdp.GrowthStatusProd);

% monthlygdp(end,:)=[];

monthlygdp = [monthlygdp ConsGrowth ConsGrowthrate];

for i = 1:height(monthlygdp)
    if monthlygdp.ConsGrowthRate(i) < 0
        StatusCons{i} ='Decline';
       
    else
        StatusCons{i} ='Growth';
    end

end

StatusCons = StatusCons';
GrowthStatusCons = array2table(StatusCons,'VariableNames',{'GrowthStatusCons'});
monthlygdp = [monthlygdp GrowthStatusCons];
monthlygdp.GrowthStatusCons = categorical(monthlygdp.GrowthStatusCons);
% monthlygdp(end,:)=[];

monthlygdp = [monthlygdp ServGrowth ServGrowthrate];

for i = 1:height(monthlygdp)
    if monthlygdp.ServGrowthRate(i) < 0
        StatusServ{i} ='Decline';
       
    else
        StatusServ{i} ='Growth';
    end

end

StatusServ = StatusServ';
GrowthStatusServ = array2table(StatusServ,'VariableNames',{'GrowthStatusServ'});
monthlygdp = [monthlygdp GrowthStatusServ];
monthlygdp.GrowthStatusServ = categorical(monthlygdp.GrowthStatusServ);
save('monthlygdp.mat','monthlygdp');
writetable(monthlygdp);
clear all;
clc;
%% A3 - upload of Interest Rate 
% source - https://www.bankofengland.co.uk/boeapps/database/Bank-Rate.asp

%BoE Interest Rates table only has values only when the interest rate
%changes. hence a number of consecutive months are missing. these are
%filled first by completing the table for missing months between the chosen
%period of 1998 to 2021 and then by filling in the Interest Rate value from
%the available previous month's value
%filled in the below section using previous month's value

opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A3:B49";

% Specify column names and types
opts.VariableNames = ["DateChanged", "Rate"];
opts.VariableTypes = ["string", "double"];

% Specify variable properties
opts = setvaropts(opts, "DateChanged", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "DateChanged", "EmptyFieldRule", "auto");

% Import the data
RateHistoryBoE = readtable("C:\Users\aruna\OneDrive\Documents\GitH\ML CW\sourcefiles\BankRatehistoryBoE.xlsx", opts, "UseExcel", false);
RateHistoryBoE.DateChanged = datetime(RateHistoryBoE.DateChanged,'Format','yyyy-MM','InputFormat','dd MMM yy') ;
RateHistoryBoE.Properties.VariableNames = {'Period' 'InterestRate'} ;
AddRecord = {'2021-11','0.1'};
AddRecordTable = array2table(AddRecord);
AddRecordTable.Properties.VariableNames = {'Period' 'InterestRate'};
AddRecordTable.Period = datetime(AddRecordTable.Period,'Format','yyyy-MM','InputFormat','yyyy-MM');
AddRecordTable.InterestRate = cellfun(@str2num, AddRecordTable.InterestRate);
amendedBoERates = [AddRecordTable;RateHistoryBoE];
save('amendedBoERates.mat','amendedBoERates');
writetable(amendedBoERates);
clear all;
clc;

%%
