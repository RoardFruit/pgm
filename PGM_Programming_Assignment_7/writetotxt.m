% AssignmentToIndex Convert assignment to index.
%
%   I = AssignmentToIndex(A, D) converts an assignment, A, over variables
%   with cardinality D to an index into the .val vector for a factor. 
%   If A is a matrix then the function converts each row of A to an index.
%
%   See also IndexToAssignment.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012
fid=fopen('1.txt','wt');
for i=1:3926
    feature=featureSet.features(i);
    var=feature.var;
    assignment=feature.assignment;
    paramIdx=feature.paramIdx;
    l=length(var);
    if l==1
        fprintf(fid,'%d ', var);
        fprintf(fid,'%d ', assignment);
        fprintf(fid,'%d\n', paramIdx);
    else
        fprintf(fid,'%d,', var(1));
        fprintf(fid,'%d ', var(2));
        fprintf(fid,'%d,', assignment(1));
        fprintf(fid,'%d ', assignment(2));
        fprintf(fid,'%d\n', paramIdx);
    end
end
fclose(fid)
        
    

