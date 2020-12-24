function [ mat_A ] = fast_my_tenmat( A,n )
%MY_TENMAR Summary of this function goes here
%   Detailed explanation goes here
% size_A = size(A);N = size_A(end);
% mat_A = reshape(permute(A,[4 1 2 3]), N,prod(size_A(1:end-1)));
N = ndims(A);
sz = size(A);
if(n==1)
    if(isreal(A))
        mat_A = reshape_1(A,int32([sz(n),prod(sz([1:n-1,n+1:N])),1]));
    else
%         mat_A = reshape(A(:),sz(n),prod(sz([1:n-1,n+1:N])));
        mat_A = reshape_1(A,int32([sz(n),prod(sz([1:n-1,n+1:N])),0]));
    end
elseif(n==N)
    if(isreal(A))
        mat_A = reshape_N(A,int32([sz(n),prod(sz([1:n-1,n+1:N]))]))';
    else
        mat_A = reshape(A(:),prod(sz([1:n-1,n+1:N])),sz(n))';
    end
else
    order = [n,1:n-1,n+1:N];
    newdata = permute(A,order);
%     mat_A = reshape(newdata,sz(n),prod(sz([1:n-1,n+1:N])));
    if(isreal(A))
        mat_A = reshape_1(newdata,int32([sz(n),prod(sz([1:n-1,n+1:N])),1]));
    else
%         mat_A = reshape(newdata,sz(n),prod(sz([1:n-1,n+1:N])),0);
        mat_A = reshape_1(newdata,int32([sz(n),prod(sz([1:n-1,n+1:N])),0]));
    end
end

end


% function [ mat_A ] = fast_my_tenmat( A,n,sz )
% %MY_TENMAR Summary of this function goes here
% %   Detailed explanation goes here
% % size_A = size(A);N = size_A(end);
% % mat_A = reshape(permute(A,[4 1 2 3]), N,prod(size_A(1:end-1)));
% N = ndims(A);
% % sz = size(A);
% if(n==1)
%     mat_A = reshape(A(:),sz(n),prod(sz([1:n-1,n+1:N])));
% elseif(n==N)
%     mat_A = reshape(A(:),prod(sz([1:n-1,n+1:N])),sz(n))';
% else
%     order = [n,1:n-1,n+1:N];
%     newdata = permute(A,order);
%     mat_A = reshape(newdata,sz(n),prod(sz([1:n-1,n+1:N])));
% end
% 
% end


