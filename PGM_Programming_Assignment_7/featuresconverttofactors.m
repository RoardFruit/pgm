function factors = featuresconverttofactors( features,numHiddenStates,theta)
%FEATURESCONVERTTOFACTORS Summary of this function goes here
%   Detailed explanation goes here
N=length(features);
total=2;
factors(1).var=features(1).var;
factors(1).card=repmat(numHiddenStates,1,length(features(1).var));
factors(1).val=ones(1,prod(factors(1).card));
factors(1).val(AssignmentToIndex(features(1).assignment,factors(1).card))=exp(theta(features(1).paramIdx));
for i=2:N
    find=0;
    for j=1:length(factors)
        if(isequal(features(i).var,factors(j).var))
        factors(j).val(AssignmentToIndex(features(i).assignment,factors(j).card))=factors(j).val(AssignmentToIndex(features(i).assignment,factors(j).card))*exp(theta(features(i).paramIdx));
        find=1;
        end
    end
    if(~find)
factors(total).var=features(i).var;
factors(total).card=repmat(numHiddenStates,1,length(features(i).var));
factors(total).val=ones(1,prod(factors(total).card));
factors(total).val(AssignmentToIndex(features(i).assignment,factors(total).card))=exp(theta(features(i).paramIdx));
total=total+1;
    end
end
end

