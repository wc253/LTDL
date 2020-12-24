function filtered = NLM3D( noisy, v, f1, f2, r )

%==========================================================================
% Calculates the filtered MSI using 3D non-local means filtering with
%   sub-band mixing [1]. This function depends on toolbox naonlm3d.
%
% Syntax:
%   filtered = NLM3D( noisy, v, f1, f2, r );
%
% Input:
%   noisy - noisy MSI
%   v - radius of search area
%   f1 - radius of similarity patch (small)
%   f2 - radius of similarity patch (big)
%   r - noise model flag: Rician(1), Gaussian(0)
%   
% Output:
%   filtered - denoised MSI
%
% [1] J. V. Manjon, P. Coupe, L. Marti-Bonmati, et al.. Adaptive non-local
%     means denoising of MR images with spatially varying noise levels. 
%     Journal of Magnetic Resonance Imaging, 31(1):192¨C203, 2010.
%
% by Yi Peng
%==========================================================================

min_val = min(noisy(:));
noisy = noisy - min_val;
fimau = MABONLM3D(noisy, v, f1, r);
fimao = MABONLM3D(noisy, v, f2, r);
% mixing of the coefficient of fimau and the high subbands of fimao
filtered = mixingsubband(fimau, fimao);
filtered = filtered + min_val;

end

