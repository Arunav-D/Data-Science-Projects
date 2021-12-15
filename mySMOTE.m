function allData_smote = mySMOTE(allData, sortedIDX,k)
% adapted for coursework from https://uk.mathworks.com/matlabcentral/fileexchange/70315-smote-over-sampling
% 
% mySMOTE  Synthetic Minority Oversampling Technique. A technique to
% generate synthetic samples as given in: https://www.jair.org/media/953/live-953-2037-jair.pdf
%   Usage:
%   X_smote = mySMOTE(X, N, k) 
%   
%   Inputs:
%   allData: Original dataset
%   k: number of nearest neighbors to consider while performing
%   augmentation
%   sortedIDX: sorted labels
% 
%   Outputs:
%   X_smote: augmented dataset containing original data as well.
%   
%   See also datasample, randsample
%% plot the bar plot for number of classes
figure
%SIDX1=categorical(SIDX)
barh(sortedIDX)
ylabel('number of classes-->')
xlabel('Sampels in each class-->')
title('Original imbalance data distirbution')
%% number of each classes


labels=allData(:,end);
labelsmod=table2array(labels);
class=unique(sortedIDX);
classmod=categorical(class);
for ii=1:numel(class)
    classNo(ii)=numel(find(labelsmod==class(ii)));
end

%% required addon samples in each minority class
%add on samples will be calculated by taking the difference of each
%classSamples with highest number of class samples
[maximumSamples,sampleClass]=max(classNo); % number of maximum samples
for ii=1:numel(class)
    samplediff(ii)=maximumSamples-classNo(ii);
    N (ii) = ceil(samplediff(ii)/50);
    
end

%% oversample the minority classes

allData_smote=[];
for ii=1:numel(class)
    Xtemp=allData(labelsmod==class(ii),:);
    X=table2array(Xtemp);
    T = size(X, 1);
    X_smote = X;
    for i = 1:T
        y = X(i,:);
        % find k-nearest samples
        [idx, ~] = knnsearch(X,y,'k',k);
        % retain only N out of k nearest samples
        idx = datasample(idx, N(ii));
        x_nearest = X(idx,:);
        x_syn = bsxfun(@plus, bsxfun(@times, bsxfun(@minus,x_nearest,y), rand(N(ii),1)), y);
        X_smote = cat(1, X_smote, x_syn);
    end
    allData_smote=cat(1,allData_smote,X_smote);
end
%%
balanced_sortedIDX=allData_smote(:,end);
figure
barh(balanced_sortedIDX)
ylabel('number of classes-->')
xlabel('Sampels in each class-->')
title('Balanced data distirbution')
%% randomize the data
shuffleindex=randperm(size(allData_smote,1));
allData_smote=allData_smote(shuffleindex,:);
end
