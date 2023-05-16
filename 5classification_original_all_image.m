clc;
clear all;
close all;

stenosis=load('stenosisfeature_lbp_glcm4_scpd.mat');
nonstenosis=load('nonstenosisfeature_lbp_glcm4_scpd.mat');

featurestenosis=stenosis.featurestenosis;
featurenonstenosis=nonstenosis.featurenonstenosis;

train=[featurestenosis(1:end,1:643);featurenonstenosis(1:end,1:643)];
trainlabel=[featurestenosis(1:end,644);featurenonstenosis(1:end,644)];


indices = crossvalind('kfold',trainlabel,10);
confusionMatrix = cell(1,1);
errorMat = zeros(1,10);
for i = 1:10
    Te = (indices==i);
    Tr = ~Te;
%   svm=fitcsvm(train(Tr,:),trainlabel(Tr),'KernelScale','auto','Standardize',true,'OutlierFraction',0.1);
    knn = fitcknn(train(Tr,:),trainlabel(Tr),'NumNeighbors',3,'Standardize',1, 'Distance','euclidean');
% tree = fitctree(train,trainlabel,'MinParent',7);
% disc = fitcdiscr(train,trainlabel);
    y = knn.predict(train(Te,:));
    %trainlabel(Te)
    index = cellfun(@strcmp,num2cell(y),num2cell(trainlabel(Te)));
    errorMat(i) = sum(index)/length(y);
    confusionMatrix{i} = confusionmat(trainlabel(Te),y);
    
    Ctest = confusionmat(trainlabel(Te),y);
    TN=Ctest(1,1);
    FP=Ctest(1,2);
    FN=Ctest(2,1);
    TP=Ctest(2,2);
    
    True_negative{i}=TN;
    False_Positive{i}=FP;
    False_Negative{i}=FN;
    True_Positive{i}=TP;
    
    accuracy{i} = (TP + TN)/(TP + FP + FN + TN) *100 ;
    precision{i} = TP / (TP + FP) *100;
    recall{i} = TP / (TP + FN)*100; % or TPR or sensitivity, recall, hit rate, or true positive rate
    specificity{i} = TN / (FP + TN) *100;% specificity, selectivity or true negative rate
    f_score{i} = 2*TP/(2*TP + FP + FN)*100;
    TNR{i}= TN/(TN+FP)*100; 
    
end

% Calculate misclassification error
cvError = 1-mean(errorMat); 