function predict = CRFPredict( X,theta,modelParams)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
featureSet = GenerateAllFeatures(X, modelParams);
factors=featuresconverttofactors(featureSet.features,modelParams.numHiddenStates,theta);
M = ComputeExactMarginalsBP(factors, [], 1);
predict=MaxDecoding( M );

end

