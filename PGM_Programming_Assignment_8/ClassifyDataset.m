function accuracy = ClassifyDataset(dataset, labels, P, G)
% returns the accuracy of the model P and graph G on the dataset 
%
% Inputs:
% dataset: N x 10 x 3, N test instances represented by 10 parts
% labels:  N x 2 true class labels for the instances.
%          labels(i,j)=1 if the ith instance belongs to class j 
% P: struct array model parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description) 
%
% Outputs:
% accuracy: fraction of correctly classified instances (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset, 1);
accuracy = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = size(labels,2);
predict=zeros(size(labels));
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
            p=p+lognormpdf(dataset(i,j,1),P.clg(j).mu_y(k),P.clg(j).sigma_y(k));
            p=p+lognormpdf(dataset(i,j,2),P.clg(j).mu_x(k),P.clg(j).sigma_x(k));
            p=p+lognormpdf(dataset(i,j,3),P.clg(j).mu_angle(k),P.clg(j).sigma_angle(k));
         else
            p=p+lognormpdf(dataset(i,j,1),P.clg(j).theta(k,1)+P.clg(j).theta(k,2)*dataset(i,parent,1)+P.clg(j).theta(k,3)*dataset(i,parent,2)+P.clg(j).theta(k,4)*dataset(i,parent,3),P.clg(j).sigma_y(k));
            p=p+lognormpdf(dataset(i,j,2),P.clg(j).theta(k,5)+P.clg(j).theta(k,6)*dataset(i,parent,1)+P.clg(j).theta(k,7)*dataset(i,parent,2)+P.clg(j).theta(k,8)*dataset(i,parent,3),P.clg(j).sigma_x(k));
            p=p+lognormpdf(dataset(i,j,3),P.clg(j).theta(k,9)+P.clg(j).theta(k,10)*dataset(i,parent,1)+P.clg(j).theta(k,11)*dataset(i,parent,2)+P.clg(j).theta(k,12)*dataset(i,parent,3),P.clg(j).sigma_angle(k));
         end
        end
       predict(i,k)=p; 
    end
end
correct=0;
for i=1:N
    [ma,index1]=max(labels(i,:));
    [mb,index2]=max(predict(i,:));
    if(index1==index2) 
        correct=correct+1;
    end
end
accuracy=correct/N;
fprintf('Accuracy: %.2f\n', accuracy);