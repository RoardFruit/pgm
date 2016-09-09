% AssignmentToIndex Convert assignment to index.
%
%   I = AssignmentToIndex(A, D) converts an assignment, A, over variables
%   with cardinality D to an index into the .val vector for a factor. 
%   If A is a matrix then the function converts each row of A to an index.
%
%   See also IndexToAssignment.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012
fid=fopen('2.txt','wt');
l=length(sampleTheta);
for i=1:l
 fprintf(fid,'%.15f\n', sampleTheta(i))
end
fclose(fid)
        
    

