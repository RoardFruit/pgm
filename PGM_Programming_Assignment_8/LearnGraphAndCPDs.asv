function [P G loglikelihood] = LearnGraphAndCPDs(dataset, labels)

% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha) 
% labels: N x 2 true class labels for the examples. labels(i,j)=1 if the 
%         the ith example belongs to class j
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
K = size(labels,2);

G = zeros(10,2,K); % graph structures to learn
% initialization
for k=1:K
    G(2:end,:,k) = ones(9,2);
end

% estimate graph structure for each class
for k=1:K
    % fill in G(:,:,k)
    % use ConvertAtoG to convert a maximum spanning tree to a graph G
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    %%%%%%%%%%%%%%%%%%%%%%%%%
    [A W] = LearnGraphStructure(dataset(labels(:,k)==1,:,:));
    G(:,:,k)=ConvertAtoG(A);
end

% estimate parameters

P.c = zeros(1,K);
% compute P.c

% the following code can be copied from LearnCPDsGivenGraph.m
% with little or no modification
%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:K
    P.c(k)=sum(labels(:,k)==1)/N;
end
for i=1:size(G,1)
    for k=1:K
      if(G(i,1,k)==0)       
        [P.clg(i).mu_y(k),P.clg(i).sigma_y(k)]=FitGaussianParameters(dataset(labels(:,k)==1,i,1));
        [P.clg(i).mu_x(k),P.clg(i).sigma_x(k)]=FitGaussianParameters(dataset(labels(:,k)==1,i,2));
        [P.clg(i).mu_angle(k),P.clg(i).sigma_angle(k)]=FitGaussianParameters(dataset(labels(:,k)==1,i,3));
       else
        [P.clg(i).theta(k,[2:4 1]) P.clg(i).sigma_y(k)]=FitLinearGaussianParameters(dataset(labels(:,k)==1,i,1),reshape(dataset(labels(:,k)==1,G(i,2,k),:),[],3));
        [P.clg(i).theta(k,[6:8 5]) P.clg(i).sigma_x(k)]=FitLinearGaussianParameters(dataset(labels(:,k)==1,i,2),reshape(dataset(labels(:,k)==1,G(i,2,k),:),[],3));
        [P.clg(i).theta(k,[10:12 9]) P.clg(i).sigma_angle(k)]=FitLinearGaussianParameters(dataset(labels(:,k)==1,i,3),reshape(dataset(labels(:,k)==1,G(i,2,k),:),[],3));
      end
    end
end
loglikelihood=ComputeLogLikelihood(P, G, dataset);
fprintf('log likelihood: %f\n', loglikelihood);