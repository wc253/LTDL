function [ U,S,V,W ] = fast_NL_d_HOSVD(A,B,modified,M)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
[~,~,D]=size(A(:,:,:,1));U = zeros(D,D,D);V = U;

if(modified == 1)
    A = ffd(A,M);B = ffd(B,M);
else
     A = ffd(A,M);
end

for k=1:D
    [U(:,:,k),V(:,:,k),W(:,:,k)]=tucker(A,k);
end




S = A;
for k = 1:D
    if(modified == 1)
        Ak = B(:,:,k,:);
    else
        Ak = A(:,:,k,:);
    end
    Uk = U(:,:,k);Vk = V(:,:,k);Wk = W(:,:,k);
    Sk1 = my_ttm(Ak,Uk,1,'t');Sk2 = my_ttm(Sk1,Vk,2,'t');Sk3 = my_ttm(Sk2,Wk,4,'t');
    S(:,:,k,:) = Sk3;
end



end


function[U,V,W]=tucker(A,k)

A_d = A(:,:,k,:);
A1 = my_tenmat(A_d,1);[U,~] = eig(A1*A1');
A2 = my_tenmat(A_d,2);[V,~] = eig(A2*A2');
A3 = my_tenmat(A_d,4);[W,~] = eig(A3*A3');

end