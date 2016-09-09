function theta = CRFTarinSGD(traindata,modelParams,max)
%CRFTARINSGD Summary of this function goes here
%   Detailed explanation goes here
theta=zeros(1,2366);
for i=1:max
    a=1/(0.05*i+1);
    j = mod(i, size(traindata,2))+1;
    [cost,grad]=InstanceNegLogLikelihood(traindata(j).X, traindata(j).y, theta, modelParams);
    theta=theta-a*grad;
end

end

