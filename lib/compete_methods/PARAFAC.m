function [X, k] = PARAFAC(Y, delta1, delta2)

%==========================================================================
% Calculates result of parallel factor analysis (PARAFAC) for MSI with
%   adaptive rank estimation [1].
%
% Syntax:
%   [X, k] = PARAFAC(Y, delta1, delta2)
%
% Input:
%   Y - the I1 x I2 x I3 noisy imagery tensor
%   delta1 - threshold for constancy of diagonal elements in residual
%            covariance matrix Cn (n = 1, 2, 3) (default 1E-7, see more
%            details in [1])
%   delta2 - threshold for energy finiteness of off-diagonal elements in Cn
%            (default  1E-6, see more details in [1])
%
% Output:
%   X - the I1 x I2 x I3 denoised imagery tensor
%   k - estimated rank of the iamgery
%
% [1] X. Liu, S. Bourennane, and C. Fossati, "Denoising of Hyperspectral
%     Images Using the PARAFAC Model and Statistical Performance Analysis",
%     presented at IEEE Trans. Geoscience and Remote Sensing, 2012, pp.
%     3717-3724.
%
% by Yi Peng
%==========================================================================

% thresholds of best rank criterion
if nargin < 3
    delta2 = 1e-6;
    if nargin < 2
        delta1 = 1e-7;
    end
end

typename = class(Y);
if ~strcmp(typename, 'tensor')
    Y = tensor(Y);
end
I = size(Y);
if numel(I) == 2
    I(3) = 1;
end

K = min(I);
for k = 1:K
    X = tensor(cp_als(Y, k, 'init', 'nvecs', 'printitn', 0));
    % see if covariance matrix of removed noise approach to a scalar matrix
    Noise = Y - X;
    matched = false(1, 3);
    for i = 1:3
        Nflat = double(tenmat(Noise, i));
        Ci = cov(Nflat');
        cond1 = var(diag(Ci)) < delta1;
        cond2 = abs(sum(Ci(:).^2) - sum(diag(Ci).^2))/I(i)^2 < delta2;
        matched(i) = cond1 & cond2; 
    end
    if all(matched)
        X = double(X);
        return;
    end
end
X = double(X);