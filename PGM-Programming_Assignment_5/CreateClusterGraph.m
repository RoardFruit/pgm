%CREATECLUSTERGRAPH Takes in a list of factors and returns a Bethe cluster
%   graph. It also returns an assignment of factors to cliques.
%
%   C = CREATECLUSTERGRAPH(F) Takes a list of factors and creates a Bethe
%   cluster graph with nodes representing single variable clusters and
%   pairwise clusters. The value of the clusters should be initialized to 
%   the initial potential. 
%   It returns a cluster graph that has the following fields:
%   - .clusterList: a list of the cluster beliefs in this graph. These entries
%                   have the following subfields:
%     - .var:  indices of variables in the specified cluster
%     - .card: cardinality of variables in the specified cluster
%     - .val:  the cluster's beliefs about these variables
%   - .edges: A cluster adjacency matrix where edges(i,j)=1 implies clusters i
%             and j share an edge.
%  
%   NOTE: The index of the cluster for each factor should be the same within the
%   clusterList as it is within the initial list of factors.  Thus, the cluster
%   for factor F(i) should be found in P.clusterList(i) 
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CreateClusterGraph(F, Evidence)
P.clusterList = [];
P.edges = [];
for j = 1:length(Evidence),
    if (Evidence(j) > 0),
        F = ObserveEvidence(F, [j, Evidence(j)]);
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C.nodes = {};

V = unique([F(:).var]);

% Setting up the cardinality for the variables since we only get a list 
% of factors.
C.card = zeros(1, length(V));
for i = 1 : length(V),

	 for j = 1 : length(F)
		  if (~isempty(find(F(j).var == i)))
				C.card(i) = F(j).card(find(F(j).var == i));
				break;
		  end
	 end
end

C.factorList = F;

singlevar=[];

for i=1:length(F)
    C.nodes{i}=F(i).var;
    if(length(F(i).var)==1) 
        singlevar(end+1)=F(i).var;
    end
end


for i=1:length(V)
    if (isempty(find(singlevar == V(i))))
        C.nodes{end+1}=V(i);
    end
end

C.edges = zeros(length(C.nodes));

for i = 1:length(C.nodes)
	 for j = 1:length(C.nodes)
		  if(i~=j&&isempty(setdiff(C.nodes{i},C.nodes{j})))
              C.edges(i,j)=1;
              C.edges(j,i)=1;
		  end
	 end
end

P1 = ComputeInitialPotentials(C);
P.edges=P1.edges;
P.clusterList=P1.cliqueList;
    




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

