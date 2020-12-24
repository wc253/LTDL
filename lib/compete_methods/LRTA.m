function [X, Z, K] = LRTA(Y)

%==========================================================================
% Implements the lower rank tensor approximation (LRTA) for MSI [1].
%
% Syntax:
%   [X, Z, K] = LRTA(Y);
%
% Input:
%   Y - the I1 x I2 x I3 noisy imagery tensor
%   
% Output:
%   X - the denoised imagery tensor whose size is equal to Y's
%   Z - the I1 x I2 x D3 reducing tensor after DR
%   K - estimated n-rank of the imagery
%
% [1] N. Renard, S. Bourennane, and J. Blanc-Talon, "Denoising and
%     Dimensionality Reduction Using Multilinear Tools for Hyperspectral
%     Images", IEEE Geoscience and Remote Sensing Letters, vol. 5, no. 2,
%     Apr. 2008.
%
% by Yi Peng
%==========================================================================

typename = class(Y);
if ~strcmp(typename, 'tensor')
    Y = tensor(Y);
end
I = size(Y);
if numel(I) == 2
    I(3) = 1;
end

% remove the average of each band
Yflat = double(tenmat(Y, 3));
bandwise_avg = mean(Yflat, 2);
Y = Y - reshape(repmat(bandwise_avg, [1, I(1)*I(2)])', I);

% estimate K1, K2 and K3
K = zeros(1, 3);
for k = 1:3
    Yflat = double(tenmat(Y, k));
    AICscore = DimDetectAIC(Yflat');
    [~, K(k)] = min(AICscore);
end

% denoising via LRTA
X = tucker_als(Y, K, 'init', 'nvecs', 'tol', 1e-8, 'printitn', 0);

% perform DR to improve classification performance
Z = ttm(X.core, X.U, -3);

X = tensor(X) + reshape(repmat(bandwise_avg, [1, I(1)*I(2)])', I);
