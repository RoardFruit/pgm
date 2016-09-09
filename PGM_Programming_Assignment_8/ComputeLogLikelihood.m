function loglikelihood = ComputeLogLikelihood(P, G, dataset)
% returns the (natural) log-likelihood of data given the model and graph structure
%
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
% 
% Output:
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1); % number of examples
K = length(P.c); % number of classes

loglikelihood = 0;
% You should compute the log likelihood of data as in eq. (12) and (13)
% in the PA description
% Hint: Use lognormpdf instead of log(normpdf) to prevent underflow.
%       You may use log(sum(exp(logProb))) to do addition in the original
%       space, sum(Prob).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gsize=size(G);

for i=1:N
    logp=0;
    for k=1:K
        p=0;
       for j=1:Gsize(1)  
    if(length(Gsize)>2)
        G1=G(j,1,k);
        parent=G(j,2,k);
    else
        G1=G(j,1);
        parent=G(j,2);
    end
        if(G1==0)
            p=p+lognormpdf(dataset(i,j,1),P.clg(j).mu_y(k),P.clg(j).sigma_y(k));
            p=p+lognormpdf(dataset(i,j,2),P.clg(j).mu_x(k),P.clg(j).sigma_x(k));
            p=p+lognormpdf(dataset(i,j,3),P.clg(j).mu_angle(k),P.clg(j).sigma_angle(k));
        else
      %      parent=G(j,2,K);
            p=p+lognormpdf(dataset(i,j,1),P.clg(j).theta(k,1)+P.clg(j).theta(k,2)*dataset(i,parent,1)+P.clg(j).theta(k,3)*dataset(i,parent,2)+P.clg(j).theta(k,4)*dataset(i,parent,3),P.clg(j).sigma_y(k));
            p=p+lognormpdf(dataset(i,j,2),P.clg(j).theta(k,5)+P.clg(j).theta(k,6)*dataset(i,parent,1)+P.clg(j).theta(k,7)*dataset(i,parent,2)+P.clg(j).theta(k,8)*dataset(i,parent,3),P.clg(j).sigma_x(k));
            p=p+lognormpdf(dataset(i,j,3),P.clg(j).theta(k,9)+P.clg(j).theta(k,10)*dataset(i,parent,1)+P.clg(j).theta(k,11)*dataset(i,parent,2)+P.clg(j).theta(k,12)*dataset(i,parent,3),P.clg(j).sigma_angle(k));
        end
       end
       logp=logp+exp(p+log(P.c(k)));
    end
    loglikelihood=loglikelihood+log(logp);
end
