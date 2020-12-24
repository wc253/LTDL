function [ A_UV ] = my_ttm2( A,U,V,tflag )
%MY_TTM Summary of this function goes here
%   Detailed explanation goes here
n = ndims(A);
N = ndims(A);
sz = size(A);
order = [n,1:n-1,n+1:N];
newdata = double(permute(A,order));
newdata = reshape(newdata,sz(n),prod(sz([1:n-1,n+1:N])));
if tflag == 't'
    newdata = U'*newdata*V;
    p = size(U,2);
else
    newdata = U*newdata*V';
    p = size(U,1);
end
newsz = [p,sz(1:n-1),sz(n+1:N)];
newdata = reshape(newdata,[newsz 1 1]);
A_UV = ipermute(newdata,order);
end

