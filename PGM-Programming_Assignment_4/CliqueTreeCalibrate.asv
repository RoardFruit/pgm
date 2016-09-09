%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for 
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P 
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function 
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)


% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j. 
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if(isMax==1)
     for i=1:N
        P.cliqueList(i).val=log(P.cliqueList(i).val);
     end
 end
for m=1:2*(N-1)
    [i, j] = GetNextCliques(P, MESSAGES);
    nb=find(P.edges(i,:)==1);
    nb(nb==j)=[];
    F = repmat(struct('var', [], 'card', [], 'val', []), 1, length(nb)+1);
    F(1)=P.cliqueList(i);
    F(2:end)=MESSAGES(nb,i);
    V=setdiff(P.cliqueList(i).var,P.cliqueList(j).var);
    if(isMax==0)
    MESSAGES(i,j)=FactorMarginalization(ComputeJointDistribution(F),V);
    MESSAGES(i,j).val=MESSAGES(i,j).val/sum(MESSAGES(i,j).val);
    end
    if(isMax==1)
    MESSAGES(i,j)=FactorMaxMarginalization(ComputeSumDistribution(F),V);
    end
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated. 
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    nb=find(P.edges(i,:)==1);
    F = repmat(struct('var', [], 'card', [], 'val', []), 1, length(nb)+1);
    F(1)=P.cliqueList(i);
    F(2:end)=MESSAGES(nb,i);
    if(isMax==0)
    P.cliqueList(i)=ComputeJointDistribution(F);
    end
    if(isMax==1)
    P.cliqueList(i)=ComputeSumDistribution(F);
    end
end
return
