% File: EM_HMM.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [P loglikelihood ClassProb PairProb] = EM_HMM(actionData, poseData, G, InitialClassProb, InitialPairProb, maxIter)

% INPUTS
% actionData: structure holding the actions as described in the PA
% poseData: N x 10 x 3 matrix, where N is number of poses in all actions
% G: graph parameterization as explained in PA description
% InitialClassProb: N x K matrix, initial allocation of the N poses to the K
%   states. InitialClassProb(i,j) is the probability that example i belongs
%   to state j.
%   This is described in more detail in the PA.
% InitialPairProb: V x K^2 matrix, where V is the total number of pose
%   transitions in all HMM action models, and K is the number of states.
%   This is described in more detail in the PA.
% maxIter: max number of iterations to run EM

% OUTPUTS
% P: structure holding the learned parameters as described in the PA
% loglikelihood: #(iterations run) x 1 vector of loglikelihoods stored for
%   each iteration
% ClassProb: N x K matrix of the conditional class probability of the N examples to the
%   K states in the final iteration. ClassProb(i,j) is the probability that
%   example i belongs to state j. This is described in more detail in the PA.
% PairProb: V x K^2 matrix, where V is the total number of pose transitions
%   in all HMM action models, and K is the number of states. This is
%   described in more detail in the PA.

% Initialize variables
N = size(poseData, 1);
K = size(InitialClassProb, 2);
L = size(actionData, 2); % number of actions
V = size(InitialPairProb, 1);

ClassProb = InitialClassProb;
PairProb = InitialPairProb;

loglikelihood = zeros(maxIter,1);

P.c = [];
P.clg.sigma_x = [];
P.clg.sigma_y = [];
P.clg.sigma_angle = [];

% EM algorithm
for iter=1:maxIter
  
  % M-STEP to estimate parameters for Gaussians
  % Fill in P.c, the initial state prior probability (NOT the class probability as in PA8 and EM_cluster.m)
  % Fill in P.clg for each body part and each class
  % Make sure to choose the right parameterization based on G(i,1)
  % Hint: This part should be similar to your work from PA8 and EM_cluster.m
  
  P.c = zeros(1,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  indexS1=[];
  for i=1:L
      indexS1(i)=actionData(i).marg_ind(1);
  end
  P.c=sum(ClassProb(indexS1,:))/sum(sum(ClassProb(indexS1,:)));
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
  
  % M-STEP to estimate parameters for transition matrix
  % Fill in P.transMatrix, the transition matrix for states
  % P.transMatrix(i,j) is the probability of transitioning from state i to state j
  P.transMatrix = zeros(K,K);
  
  % Add Dirichlet prior based on size of poseData to avoid 0 probabilities
  P.transMatrix = P.transMatrix + size(PairProb,1) * .05;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  sumPair=sum(PairProb);
  for i=1:K
      for j=1:K
        index=AssignmentToIndex([i j],[K K]);
        P.transMatrix(i,j)= P.transMatrix(i,j)+sumPair(index);
      end
  end
 P.transMatrix=bsxfun(@rdivide,P.transMatrix,sum(P.transMatrix,2));
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP preparation: compute the emission model factors (emission probabilities) in log space for each 
  % of the poses in all actions = log( P(Pose | State) )
  % Hint: This part should be similar to (but NOT the same as) your code in EM_cluster.m
  
  logEmissionProb = zeros(N,K);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % logClassProb = zeros(N,K);
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
      logEmissionProb(i,k)=p; 
    end
 end 
%logEmissionProb=bsxfun(@minus,logClassProb,logsumexp(logClassProb));
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    
  % E-STEP to compute expected sufficient statistics
  % ClassProb contains the conditional class probabilities for each pose in all actions
  % PairProb contains the expected sufficient statistics for the transition CPDs (pairwise transition probabilities)
  % Also compute log likelihood of dataset for this iteration
  % You should do inference and compute everything in log space, only converting to probability space at the end
  % Hint: You should use the logsumexp() function here to do probability normalization in log space to avoid numerical issues
  
  ClassProb = zeros(N,K);
  PairProb = zeros(V,K^2);
  loglikelihood(iter) = 0;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % YOUR CODE HERE
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:L
    factornum=length(actionData(i).marg_ind)+length(actionData(i).pair_ind)+1;
    factors=repmat(struct('var', [], 'card', [], 'val', []), factornum, 1);
    factors(1).var=1;
    factors(1).card=K;
    factors(1).val=log(P.c);
    for j=1:length(actionData(i).marg_ind)
        factors(1+j).var=j;
        factors(1+j).card=K;
        factors(1+j).val=logEmissionProb(actionData(i).marg_ind(j),:);
    end
     for j=1:length(actionData(i).pair_ind)
        factors(1+length(actionData(i).marg_ind)+j).var=[j j+1];
        factors(1+length(actionData(i).marg_ind)+j).card=[K K];
        for k=1:K*K
        assign=IndexToAssignment(k,[K K]);
        factors(1+length(actionData(i).marg_ind)+j).val(k)=log(P.transMatrix(assign(1),assign(2)));
        end
     end
    [M, PCalibrated] = ComputeExactMarginalsHMM(factors);
    for j=1:length(actionData(i).marg_ind)
        ClassProb(actionData(i).marg_ind(j),:)=exp(M(j).val);
    end
    for j=1:length(actionData(i).pair_ind)
        PairProb(actionData(i).pair_ind(j),:)=exp(PCalibrated.cliqueList(j).val-logsumexp(PCalibrated.cliqueList(j).val));
    end
    loglikelihood(iter) = loglikelihood(iter) + logsumexp(PCalibrated.cliqueList(end).val);
end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Print out loglikelihood
  disp(sprintf('EM iteration %d: log likelihood: %f', ...
    iter, loglikelihood(iter)));
  if exist('OCTAVE_VERSION')
    fflush(stdout);
  end
  
  % Check for overfitting by decreasing loglikelihood
  if iter > 1
    if loglikelihood(iter) < loglikelihood(iter-1)
      break;
    end
  end
  
end

% Remove iterations if we exited early
loglikelihood = loglikelihood(1:iter);
