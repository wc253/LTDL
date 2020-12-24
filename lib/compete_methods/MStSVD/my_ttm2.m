function [ A_U ] = my_ttm( A,U,n,tflag )
%MY_TTM Summary of this function goes here
%   Detailed explanation goes here

N = ndims(A);
sz = size(A);
order = [n,1:n-1,n+1:N];
% newdata = permute(A,order);
% newdata = reshape(newdata,sz(n),prod(sz([1:n-1,n+1:N])));
newdata = my_tenmat(A,n);
if tflag == 't'
    newdata = U'*newdata;
    p = size(U,2);
else
    newdata = U*newdata;
    p = size(U,1);
end

newsz = [p,sz(1:n-1),sz(n+1:N)];
if(n == 1)
    A_U = reshape(newdata,[newsz 1 1]);
else
    newdata = reshape(newdata,[newsz 1 1]);
    A_U = ipermute(newdata,order);
end



end

