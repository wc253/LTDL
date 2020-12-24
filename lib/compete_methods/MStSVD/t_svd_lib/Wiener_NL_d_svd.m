function [ U,C_A,C_B,V ] = Wiener_NL_d_svd(A,B,M)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
[~,~,D]=size(A(:,:,:,1));U = zeros(D,D,D);V = U;

A = ffd(A,M);B = ffd(B,M);

for k=1:D
    [U(:,:,k),V(:,:,k)]=tucker(A,k);
end

C_A = A;
C_B = B;
for k = 1:D
    Ak = A(:,:,k,:);Bk = B(:,:,k,:);
    Uk = U(:,:,k);Vk = V(:,:,k);
    CAk1 = my_ttm(Ak,Uk,1,'t');CAk2 = my_ttm(CAk1,Vk,2,'t');
    CBk1 = my_ttm(Bk,Uk,1,'t');CBk2 = my_ttm(CBk1,Vk,2,'t');
    C_A(:,:,k,:) = CAk2; C_B(:,:,k,:) = CBk2;
end

end


function[U,V]=tucker(A,k)

A_f = A(:,:,k,:);
A1 = my_tenmat(A_f,1);[U,~] = eig(A1*A1');
A2 = my_tenmat(A_f,2);[V,~] = eig(A2*A2');

end