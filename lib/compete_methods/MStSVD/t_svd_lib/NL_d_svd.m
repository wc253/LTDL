function [ U,S,V ] = NL_d_svd(A,M)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.

size_A=size(A);N_pictures=size_A(end);[~,~,D]=size(A(:,:,:,1));

for k=1:D
    [U(:,:,k),V(:,:,k)]=tucker(A,k,M);
end

for i=1:N_pictures
    A_d=ffd(A(:,:,:,i),M);A_d = double(A_d);
    for k=1:D
         S(:,:,k,i)=U(:,:,k)'*A_d(:,:,k)*V(:,:,k);
    end
    S(:,:,:,i)=iffd(S(:,:,:,i),M);
end

U=iffd(U,M);V=iffd(V,M);


end


function[U,V]=tucker(A,k,M)
size_A=size(A);N_pictures=size_A(end);
sum_A = 0;sum_U = 0;sum_V = 0;


for i=1:N_pictures
    A_d=ffd(A(:,:,:,i),M);A_d = double(A_d);
%     sum_A = sum_A + A_f(:,:,k);
    sum_U=sum_U+A_d(:,:,k)*A_d(:,:,k)';
    sum_V=sum_V+A_d(:,:,k)'*A_d(:,:,k);
end

% [U,S,V] = svd(sum_A);
% ss=diag(S);[~,index]=sort(ss,'descend');U=U(:,index(1:R));V=V(:,index(1:R));

[U,~]=eig(sum_U);
% ss=diag(S_U);[~,index]=sort(ss,'descend');U=U(:,index(1:R));
[V,~]=eig(sum_V);
% ss=diag(S_V);[~,index]=sort(ss,'descend');V=V(:,index(1:R));

end