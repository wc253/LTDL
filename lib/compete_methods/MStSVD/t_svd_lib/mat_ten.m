function [ A_t ] = mat_ten( A_mat,n,sz )
%MAT_TEN Summary of this function goes here
%   Detailed explanation goes here

N = numel(sz);
order = [n,1:n-1,n+1:N];
newsz = [sz(n),sz(1:n-1),sz(n+1:N)];
if(n == 1)
    A_t = reshape(A_mat,[newsz 1 1]);
else
    A_t = reshape(A_mat,[newsz 1 1]);
    A_t = ipermute(A_t,order);
end

end

