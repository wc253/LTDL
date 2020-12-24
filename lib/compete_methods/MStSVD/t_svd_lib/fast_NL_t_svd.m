function [ U,S,V ] = fast_NL_t_svd(A)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
[~,~,D]=size(A(:,:,:,1));size_A = size(A);N_pictures = size_A(end);S = A;
real_count = floor(D/2)+1;


for i = 1:N_pictures
    A(:,:,:,i) = fft(A(:,:,:,i),[],3);
end


for k=1:real_count
    [U(:,:,k),V(:,:,k)]=tucker(A,k);
end


for i=1:N_pictures
    A_f=A(:,:,:,i);
    for k=1:real_count
         S(:,:,k,i)=U(:,:,k)'*A_f(:,:,k)*V(:,:,k);
    end
end



end


function[U,V]=tucker(A,k)
size_A=size(A);N_pictures=size_A(end);
sum_U = 0;sum_V = 0;


for i=1:N_pictures
    A_f=A(:,:,:,i);
    sum_U=sum_U+A_f(:,:,k)*A_f(:,:,k)';
    sum_V=sum_V+A_f(:,:,k)'*A_f(:,:,k);
end

[U,~]=eig(sum_U);
[V,~]=eig(sum_V);



end