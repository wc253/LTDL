function [  ] = test_time( n )
%TEST_TIME Summary of this function goes here
%   Detailed explanation goes here
ps = 3;
A = rand(ps,ps,ps,n);B = A;tau = 0.3;sigma = 1;count = n;

for tau = 0

mat_A = my_tenmat(A,ndims(A));[U4,~] = eig(mat_A*mat_A');
A = my_ttm(A,U4,ndims(A),'t');

[U_A,S_A,V_A,W_A]=NL_t_HOSVD(A,U4);
A=fast_t_product(U_A,S_A,V_A,W_A,ps,sigma,count,tau); %this is the only thing I have to modify.
A = my_ttm(A,U4,ndims(A),'nt');

one = ones(10,1); I = diag(one);
[U_B,S_B,V_B,W_B]=NL_t_HOSVD(B,I);
B=fast_t_product(U_B,S_B,V_B,W_B,ps,sigma,count,tau); %this is the only thing I have to modify.

W_C = W_A;
for i = 1:ps
    W_C(:,:,i) = U4*W_A(:,:,i);
end

norm(S_A(:) - S_B(:))
end
% norm(U_A(:) - U_B(:))
% norm(V_A(:) - V_B(:))
% norm(W_C(:) - W_B(:))

end

function [ U,S,V,W ] = NL_t_HOSVD(A,U4)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
[~,~,D]=size(A(:,:,:,1));



for k=1:D
    [U(:,:,k),V(:,:,k),W(:,:,k)]=tucker(A,k,U4);
end




S = A;
for k = 1:D
    Ak = A(:,:,k,:);Uk = U(:,:,k);Vk = V(:,:,k);Wk = W(:,:,k);
    Sk1 = my_ttm(Ak,Uk,1,'t');Sk2 = my_ttm(Sk1,Vk,2,'t');Sk3 = my_ttm(Sk2,Wk,4,'t');
    S(:,:,k,:) = Sk3;
end



end


function[U,V,W]=tucker(A,k,U4)

A_f = A(:,:,k,:);
A1 = my_tenmat(A_f,1);[U,~] = eig(A1*A1');
A2 = my_tenmat(A_f,2);[V,~] = eig(A2*A2');
A3 = my_tenmat(A_f,4);[W,~] = eig(A3*A3');

end

function [A]=fast_t_product(U,S,V,W,ps,sigma,count,tau)

size_S=size(S);D=size_S(end-1);A = zeros(size(S));
ps1 = ps(1);ps2 = ps(1);ps3 = ps(1);


% real_count = floor(D/2)+1;

coeff_threshold = tau*sigma*sqrt(2*log(ps1*ps2*ps3*count));
S(abs(S(:)) < coeff_threshold) = 0; 
for k = 1:D
    Sk = S(:,:,k,:);Uk = U(:,:,k);Vk = V(:,:,k);Wk = W(:,:,k);
    Ak1 = my_ttm(Sk,Uk,1,'nt');Ak2 = my_ttm(Ak1,Vk,2,'nt');Ak3 = my_ttm(Ak2,Wk,4,'nt');
    A(:,:,k,:) = Ak3;
end

% A(:,:,D,:) = conj(A(:,:,2,:));
% if(D == 5)
%     A(:,:,4,:) = conj(A(:,:,3,:));
% end
% 
% A_f = ifft(A,[],3);A = A_f;

end

