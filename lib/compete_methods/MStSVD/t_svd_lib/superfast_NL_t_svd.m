function [ A ] = superfast_NL_t_svd(A,sigma,tau)
%t_hosvd compute the hosvd-like t_SVD
%   input A must be a cell 4-order tensor that contains N tensors, where N
%   represents the number of similar pictures.
[~,~,D,~]=size(A(:,:,:,1));
real_count = floor(D/2)+1;

for k=1:real_count
    [A(:,:,k,:)]=tucker(A,D,k,sigma,tau);  
end

A(:,:,D,:) = conj(A(:,:,2,:));

if(D == 5)
    A(:,:,4,:) = conj(A(:,:,3,:));
end

if(D == 6)
    A(:,:,5,:) = conj(A(:,:,3,:));
end

if(D == 7)
    A(:,:,5,:) = conj(A(:,:,4,:));
    A(:,:,6,:) = conj(A(:,:,3,:));
end

end


function[A]=tucker(A,ps,k,sigma,tau)

if(k==1)
    A_f = real(A(:,:,k,:));
elseif(ps==4&&k==3)
    A_f = real(A(:,:,k,:));
else
    A_f = A(:,:,k,:);
end

size_A = size(A_f);ps = size_A(1);count = size_A(end);

A1 = my_tenmat(A_f,1);[U,~] = eig(A1*A1');Sk1 = U'*A1;Sk1 = mat_ten(Sk1,1,size(A_f));

A2 = my_tenmat(A_f,2);[V,~] = eig(A2*A2');S = my_ttm(Sk1,V,2,'t');

coeff_threshold = tau*sigma*sqrt(2*log(ps*ps*ps*count));

S(abs(S(:)) < coeff_threshold) = 0; 
  
Ak1 = my_ttm(S,U,1,'nt');A = my_ttm(Ak1,V,2,'nt');


end


%% older version
% function [ U,S,V ] = superfast_NL_t_svd(A)
% %t_hosvd compute the hosvd-like t_SVD
% %   input A must be a cell 4-order tensor that contains N tensors, where N
% %   represents the number of similar pictures.
% [~,~,D]=size(A(:,:,:,1));U = zeros(D,D,D);V = U;
% real_count = floor(D/2)+1;
% 
% 
% A_f = fft(A,[],3);A = A_f;
% 
% for k=1:real_count
%     [U(:,:,k),V(:,:,k)]=tucker(A,k);
% end
% 
% S = A;
% for k = 1:real_count
%     Ak = A(:,:,k,:);Uk = U(:,:,k);Vk = V(:,:,k);
%     Sk1 = my_ttm(Ak,Uk,1,'t');Sk2 = my_ttm(Sk1,Vk,2,'t');
%     S(:,:,k,:) = Sk2;
% end
% 
% end
% 
% 
% function[U,V]=tucker(A,k)
% 
% A_f = A(:,:,k,:);
% A1 = my_tenmat(A_f,1);[U,~] = eig(A1*A1');
% A2 = my_tenmat(A_f,2);[V,~] = eig(A2*A2');
% 
% end