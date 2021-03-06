% You should put all your code for recognizing unknown actions in this file.
% Describe the method you used in YourMethod.txt.
% Don't forget to call SavePrediction() at the end with your predicted labels to save them for submission, then submit using submit.m

% File: RecognizeActions.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [predicted_labels] = RecognizeUnknownActions(G, maxIter)
load PA9Data;

datasetTrain = datasetTrain3;
testdata = datasetTest3;

traindata=repmat(struct('actionData', [], 'poseData', [], 'InitialClassProb', [],'InitialPairProb', []), 1, 3);
crossdata=struct('actionData', [], 'poseData', [], 'labels',[]);

for i=1:3
    traindata(i).actionData=datasetTrain(i).actionData(1:23);
    split=traindata(i).actionData(23).marg_ind(end);
    split1=traindata(i).actionData(23).pair_ind(end);
    traindata(i).poseData=datasetTrain(i).poseData(1:split,:,:);
    traindata(i).InitialClassProb=datasetTrain(i).InitialClassProb(1:split,:);
    traindata(i).InitialPairProb=datasetTrain(i).InitialPairProb(1:split1,:);
    crossdata.actionData((i-1)*7+1:i*7)=datasetTrain(i).actionData(24:30);
    crossdata.labels((i-1)*7+1:i*7)=i;
    for j=1:7
    marg_ind=traindata(i).actionData(23+j).marg_ind;
    cur=size(crossdata.poseData,1);
    crossdata.poseData(cur+1:cur+length(marg_ind),:,:)=datasetTrain(i).poseData(marg_ind,:,:);
    crossdata.actionData((i-1)*7+j).marg_ind=cur+1:cur+length(marg_ind);
    end
end

SavePredictions (predicted_labels)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
