function [ U,S,V ] = fast_t_NLPCA(A)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
[~,~,D]=size(A(:,:,:,1));
real_count = floor(D/2)+1;


A_f = fft(A,[],3);A = A_f;

for k=1:real_count
    [U(:,:,k),V(:,:,k)]=NL_PCA(A,k);
end

S = A;
for k = 1:real_count
    Ak = A(:,:,k,:);Uk = U(:,:,k);Vk = V(:,:,k);
    S(:,:,k,:) = my_ttm2(Ak,Uk,Vk,'t');
end

end


function[U,V]=NL_PCA(A,k)

Ak = A(:,:,k,:);
Ak_mat = my_tenmat(Ak,ndims(Ak));
[U,~,V] = svd(Ak_mat);

end