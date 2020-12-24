function [ U,C_A,C_B,V ] = Wiener_NL_t_svd(A,B)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
[~,~,D]=size(A(:,:,:,1));U = zeros(D,D,D);V = U;
real_count = floor(D/2)+1;


A_f = fft(A,[],3);A = A_f;
B_f = fft(B,[],3);B = B_f;

for k=1:real_count
    [U(:,:,k),V(:,:,k)]=tucker(A,k);
end

C_A = A;
C_B = B;
for k = 1:real_count
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