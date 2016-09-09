% File: EM_cluster.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb] = EM_cluster(poseData, G, InitialClassProb, maxIter)

% INPUTS
% poseData: N x 10 x 3 matrix, where N is number of poses;
%   poseData(i,:,:) yields the 10x3 matrix for pose i.
% G: graph parameterization as explained in PA8
% InitialClassProb: N x K, initial allocation of the N poses to the K
%   classes. InitialClassProb(i,j) is the probability that example i belongs
%   to class j
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K, conditional class probability of the N examples to the
%   K classes in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to class j

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);

ClassProb = InitialClassProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg.sigma_x = [];
P.clg.sigma_y = [];
P.clg.sigma_angle = [];

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  %
  % Fill in P.c with the estimates for prior class probabilities
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  %
  % Hint: This part should be similar to your work from PA8
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  P.c=sum(ClassProb)/N;
  for i=1:size(G,1)
         for k=1:K
            if(G(i,1)==0)
        [P.clg(i).mu_y(k),P.clg(i).sigma_y(k)]=FitG(poseData(:,i,1),ClassProb(:,k));
        [P.clg(i).mu_x(k),P.clg(i).sigma_x(k)]=FitG(poseData(:,i,2),ClassProb(:,k));
        [P.clg(i).mu_angle(k),P.clg(i).sigma_angle(k)]=FitG(poseData(:,i,3),ClassProb(:,k));
            else       
        [P.clg(i).theta(k,[2:4 1]) P.clg(i).sigma_y(k)]=FitLG(poseData(:,i,1),reshape(poseData(:,G(i,2),:),[],3),ClassProb(:,k));
        [P.clg(i).theta(k,[6:8 5]) P.clg(i).sigma_x(k)]=FitLG(poseData(:,i,2),reshape(poseData(:,G(i,2),:),[],3),ClassProb(:,k));
        [P.clg(i).theta(k,[10:12 9]) P.clg(i).sigma_angle(k)]=FitLG(poseData(:,i,3),reshape(poseData(:,G(i,2),:),[],3),ClassProb(:,k));
            end
         end
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % E-STEP to re-estimate ClassProb using the new parameters
  %
  % Update ClassProb with the new conditional class probabilities.
  % Recall that ClassProb(i,j) is the probability that example i belongs to
  % class j.
  %
  % You should compute everything in log space, and only convert to
  % probability space at the end.
  %
  % Tip: To make things faster, try to reduce the number of calls to
  % lognormpdf, and inline the function (i.e., copy the lognormpdf code
  % into this file)
  %
  % Hint: You should use the logsumexp() function here to do
  % probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  logClassProb = zeros(N,K);
 for i=1:N
    for k=1:K
        p=0;
        for j=1:size(G,1)
         if(length(size(G))>2)
            flag=G(j,1,k);
            parent=G(j,2,k);
         else
            flag=G(j,1);
            parent=G(j,2);
         end
         if(flag==0)
            p=p+lognormpdf(poseData(i,j,1),P.clg(j).mu_y(k),P.clg(j).sigma_y(k));
            p=p+lognormpdf(poseData(i,j,2),P.clg(j).mu_x(k),P.clg(j).sigma_x(k));
            p=p+lognormpdf(poseData(i,j,3),P.clg(j).mu_angle(k),P.clg(j).sigma_angle(k));
         else
            p=p+lognormpdf(poseData(i,j,1),P.clg(j).theta(k,1)+P.clg(j).theta(k,2)*poseData(i,parent,1)+P.clg(j).theta(k,3)*poseData(i,parent,2)+P.clg(j).theta(k,4)*poseData(i,parent,3),P.clg(j).sigma_y(k));
            p=p+lognormpdf(poseData(i,j,2),P.clg(j).theta(k,5)+P.clg(j).theta(k,6)*poseData(i,parent,1)+P.clg(j).theta(k,7)*poseData(i,parent,2)+P.clg(j).theta(k,8)*poseData(i,parent,3),P.clg(j).sigma_x(k));
            p=p+lognormpdf(poseData(i,j,3),P.clg(j).theta(k,9)+P.clg(j).theta(k,10)*poseData(i,parent,1)+P.clg(j).theta(k,11)*poseData(i,parent,2)+P.clg(j).theta(k,12)*poseData(i,parent,3),P.clg(j).sigma_angle(k));
         end
        end
      logClassProb(i,k)=p+log(P.c(k)); 
    end
 end 
 ClassProb=exp(bsxfun(@minus,logClassProb,logsumexp(logClassProb)));
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Compute log likelihood of dataset for this iteration
  % Hint: You should use the logsumexp() function here
  loglikelihood(iter) = 0;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  loglikelihood(iter)=sum(logsumexp(logClassProb));
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting: when loglikelihood decreases
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
