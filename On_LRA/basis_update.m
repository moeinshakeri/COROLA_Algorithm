function X = basis_update(A,B,X,Rank)

lambda1 = 0.001; % only works for rank 1
A_bar = A + lambda1*eye(Rank);
for i=1:Rank
X(:,i) = (1/A_bar(i,i))*(B(:,i)-X*A_bar(:,i))+X(:,i);
end
% X(:,2) = (1/A_bar(2,2))*(B(:,2)-X(:,2)*A_bar(2,2))+X(:,2);