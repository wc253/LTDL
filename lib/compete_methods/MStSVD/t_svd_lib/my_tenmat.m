function [ mat_A ] = my_tenmat( A,n )
%MY_TENMAR Summary of this function goes here
%   Detailed explanation goes here
% size_A = size(A);N = size_A(end);
% mat_A = reshape(permute(A,[4 1 2 3]), N,prod(size_A(1:end-1)));
N = ndims(A);
sz = size(A);
if(n==1)
    mat_A = reshape(A(:),sz(n),prod(sz([1:n-1,n+1:N])));
elseif(n==N)
    mat_A = reshape(A(:),prod(sz([1:n-1,n+1:N])),sz(n))';
else
    order = [n,1:n-1,n+1:N];
    newdata = permute(A,order);
    mat_A = reshape(newdata,sz(n),prod(sz([1:n-1,n+1:N])));
end

end

