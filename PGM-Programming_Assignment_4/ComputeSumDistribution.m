function Joint = ComputeSumDistribution(F)

  % Check for empty factor list
  assert(numel(F) ~= 0, 'Error: empty factor list');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% Compute the joint distribution defined by F
% You may assume that you are given legal CPDs so no input checking is required.
% Find the factor product of all of the factors
if (length(F) == 0)
	% There are no factors, so create an empty factor list
    Joint = struct('var', [], 'card', [], 'val', []);
else    
	Joint = F(1);
	for i = 2:length(F)
		% Iterate through factors and incorporate them into the joint distribution
		Joint = FactorSum(Joint, F(i));
	end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

