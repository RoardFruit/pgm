function efc = expectedfeaturecounts( P,featureSet)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N=length(featureSet.features);
efc=zeros(1,featureSet.numParams);
for i =1:N
 %     if(all(y(featureSet.features(i).var)==featureSet.features(i).assignment))
        for j=1:length(P.cliqueList)
            if(all(ismember(featureSet.features(i).var,P.cliqueList(j).var)))
                V=setdiff(P.cliqueList(j).var,featureSet.features(i).var);
                F=FactorMarginalization(P.cliqueList(j), V);
                F.val=F.val/sum(F.val);
        efc(featureSet.features(i).paramIdx)=efc(featureSet.features(i).paramIdx)+F.val(AssignmentToIndex(featureSet.features(i).assignment, F.card));
            break
            end
        end
end
% varsList = unique([P.cliqueList.var]);
% M = repmat(struct('var', 0, 'card', 0, 'val', []), length(varsList), 1);
% for i = 1:length(varsList)
%     % Iterate through variables and find the marginal for each
%     clique = struct('var', 0, 'card', 0, 'val', []);
%     currentVar = varsList(i);
%     for j = 1:length(P.cliqueList)
%         % Find a clique with the variable of interest
%         if ~isempty(find(ismember(P.cliqueList(j).var, currentVar)))
%             % A clique with the variable has been indentified
%             clique = P.cliqueList(j);
%             break
%         end
%     end
% 
%         % Do sum-product inference
%         M(i) = FactorMarginalization(clique, setdiff(clique.var, currentVar));
%         if any(M(i).val ~= 0)
%             % Normalize
%             M(i).val = M(i).val/sum(M(i).val);
%         end
% end
% for i = 1:length(P.cliqueList)
%     P.cliqueList(i).val=P.cliqueList(i).val/sum(P.cliqueList(i).val);
% end
% for i =1:N
%     if (length(featureSet.features)==1)
%         for j=1:length(M)
%             if(M(j).var==featureSet.features(i).var)
%                 efc(featureSet.features(i).paramIdx)=efc(featureSet.features(i).paramIdx)+M(j).val(AssignmentToIndex(featureSet.features(i).assignment, M(j).card));
%                 break
%             end
%         end
%     else
%         for j=1:length(P.cliqueList)
%             if(P.cliqueList(j).var==featureSet.features(i).var)
%                 efc(featureSet.features(i).paramIdx)=efc(featureSet.features(i).paramIdx)+P.cliqueList(j).val(AssignmentToIndex(featureSet.features(i).assignment, P.cliqueList(j).card));
%                 break
%             end
%         end
%     end
% end
        
            
        
end

