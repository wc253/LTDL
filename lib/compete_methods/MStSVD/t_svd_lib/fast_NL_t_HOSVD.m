function [ U,S,V,W ] = fast_NL_t_HOSVD(A,B,modified)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
[~,~,D]=size(A(:,:,:,1));U = zeros(D,D,D);V = U;
real_count = floor(D/2)+1;

if(modified == 1)
    A_f = fft(A,[],3);A = A_f;B_f = fft(B,[],3);B = B_f;
else
    A_f = fft(A,[],3);A = A_f;
end

for k=1:real_count
    [U(:,:,k),V(:,:,k),W(:,:,k)]=tucker(A,k);
end




S = A;
for k = 1:real_count
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

A_f = A(:,:,k,:);
A1 = my_tenmat(A_f,1);[U,~] = eig(A1*A1');
A2 = my_tenmat(A_f,2);[V,~] = eig(A2*A2');
A3 = my_tenmat(A_f,4);[W,~] = eig(A3*A3');

end