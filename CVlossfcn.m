function missclasfError = CVlossfcn(x,XTRAIN,ytrain,X,y,cvp,opts)
%minLS=1;
%numPTS=88;
A= TreeBagger(x.numTrees,XTRAIN,ytrain,...
    'method','classification','Options',opts,...
    'MinLeafSize',x.minLS,...
    'NumPredictorstoSample',x.numPTS)

classA = @(XTRAIN,ytrain,XTEST)predict(A,XTEST);
y1=table2array(y);
y2=categorical(y1);
missclasfError = crossval('mcr',X,y2,'predfun',classA,'partition',cvp);
end