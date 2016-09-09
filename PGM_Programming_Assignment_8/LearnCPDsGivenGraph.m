function [P loglikelihood] = LearnCPDsGivenGraph(dataset, G, labels)
%
% Inputs:
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% G: graph parameterization as explained in PA description
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j and 0 elsewhere        
%
% Outputs:
% P: struct array parameters (explained in PA description)
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
K = size(labels,2);

loglikelihood = 0;
P.c = zeros(1,K);

% estimate parameters
% fill in P.c, MLE for class probabilities
% fill in P.clg for each body part and each class
% choose the right parameterization based on G(i,1)
% compute the likelihood - you may want to use ComputeLogLikelihood.m
% you just implemented.
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:K
    P.c(k)=sum(labels(:,k)==1)/N;
end
for i=1:size(G,1)
    if(G(i,1)==0)
        for k=1:K
        [P.clg(i).mu_y(k),P.clg(i).sigma_y(k)]=FitGaussianParameters(dataset(labels(:,k)==1,i,1));
        [P.clg(i).mu_x(k),P.clg(i).sigma_x(k)]=FitGaussianParameters(dataset(labels(:,k)==1,i,2));
        [P.clg(i).mu_angle(k),P.clg(i).sigma_angle(k)]=FitGaussianParameters(dataset(labels(:,k)==1,i,3));
        end
    else
        for k=1:K
        [P.clg(i).theta(k,[2:4 1]) P.clg(i).sigma_y(k)]=FitLinearGaussianParameters(dataset(labels(:,k)==1,i,1),reshape(dataset(labels(:,k)==1,G(i,2),:),[],3));
        [P.clg(i).theta(k,[6:8 5]) P.clg(i).sigma_x(k)]=FitLinearGaussianParameters(dataset(labels(:,k)==1,i,2),reshape(dataset(labels(:,k)==1,G(i,2),:),[],3));
        [P.clg(i).theta(k,[10:12 9]) P.clg(i).sigma_angle(k)]=FitLinearGaussianParameters(dataset(labels(:,k)==1,i,3),reshape(dataset(labels(:,k)==1,G(i,2),:),[],3));
        end
    end
end
loglikelihood=ComputeLogLikelihood(P, G, dataset);
fprintf('log likelihood: %f\n', loglikelihood);

