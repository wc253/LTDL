function T = hosvd1(X,R)
%HOSVD Compute sequentially-truncated higher-order SVD (Tucker).

%% Read paramters
d = ndims(X);
dimorder = 1:d;

%% Main loop

U = cell(d,1); % Allocate space for factor matrices

for k = dimorder
    Xk = tens2mat(X,k);
    [U{k},~,~] = svd(Xk*Xk');
    U{k} = U{k}(:,1:R(k));
end
G = tmprod(X,U,dimorder,'H');

%% Final result
T = tmprod(G,U,dimorder);