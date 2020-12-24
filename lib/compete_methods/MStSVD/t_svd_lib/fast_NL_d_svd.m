function [ U,S,V ] = fast_NL_d_svd(A,M)
%t_hosvd compute the hosvd-like t_SVD

[~,~,D]=size(A(:,:,:,1));
A = ffd(A,M);
for k=1:D
    [U(:,:,k),V(:,:,k)]=d_tucker(A,k);
end

S = A;
for k = 1:D
    Ak = A(:,:,k,:);Uk = U(:,:,k);Vk = V(:,:,k);
    Sk1 = my_ttm(Ak,Uk,1,'t');Sk2 = my_ttm(Sk1,Vk,2,'t');
    S(:,:,k,:) = Sk2;
end


end


function[U,V]=d_tucker(A,k)

A_d = A(:,:,k,:);
A1 = my_tenmat(A_d,1);[U,~] = eig(A1*A1');
A2 = my_tenmat(A_d,2);[V,~] = eig(A2*A2');

end