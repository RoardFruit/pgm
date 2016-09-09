function fc = featurecounts( featureSet,y )
%WEIGHTEDFEATURECOUNTS Summary of this function goes here
%   Detailed explanation goes here
N=length(featureSet.features);
fc=zeros(1,featureSet.numParams);
for i =1:N
    if(all(y(featureSet.features(i).var)==featureSet.features(i).assignment))
        fc(featureSet.features(i).paramIdx)=fc(featureSet.features(i).paramIdx)+1;
    end
end
end

