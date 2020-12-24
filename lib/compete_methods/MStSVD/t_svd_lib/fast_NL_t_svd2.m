function [ U,S,V ] = fast_NL_t_svd2(A,B)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
size_A = size(A);
N_pictures=size_A(end);[~,~,D]=size(A(:,:,:,1));S = A;
real_count = floor(D/2)+1;

for i = 1:N_pictures
    A(:,:,:,i) = fft(A(:,:,:,i),[],3);
    B(:,:,:,i) = fft(B(:,:,:,i),[],3);
end

for k=1:real_count
    [U(:,:,k),V(:,:,k)]=tucker(A,k);
end

for i=1:N_pictures
    B_f=B(:,:,:,i);
    for k=1:real_count
         S(:,:,k,i)=U(:,:,k)'*B_f(:,:,k)*V(:,:,k);
    end
end



end


function[U,V]=tucker(A,k)
size_A=size(A);N_pictures=size_A(end);
sum_U = 0;sum_V = 0;


for i=1:N_pictures
    A_f=A(:,:,:,i);
%     sum_A = sum_A + A_f(:,:,k);
    sum_U=sum_U+A_f(:,:,k)*A_f(:,:,k)';
    sum_V=sum_V+A_f(:,:,k)'*A_f(:,:,k);
end

% [U,S,V] = svd(sum_A);
% ss=diag(S);[~,index]=sort(ss,'descend');U=U(:,index(1:R));V=V(:,index(1:R));

[U,~]=eig(sum_U);
% ss=diag(S_U);[~,index]=sort(ss,'descend');U=U(:,index(1:R));
[V,~]=eig(sum_V);
% ss=diag(S_V);[~,index]=sort(ss,'descend');V=V(:,index(1:R));

end