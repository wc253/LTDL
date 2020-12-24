addpath(genpath('data\'));
addpath('t_svd_lib');
addpath('mex');
nSig = 100;
%% using CAVE Dataset
load('chart_and_stuffed_toy_ms.mat')
O_Img = O_ImgUint8;
randn('seed', 0);
N_Img = O_Img + nSig * randn(size(O_Img));                                   %Generate noisy image
disp(['sigma = ',num2str(nSig)]);
%% test global_tSVD
ps = 8;SR = 16; N_step = 4; modified = 1; tau_tsvd = 4 ;  maxK = 30;
disp(['test with global t_SVD with ps = ',num2str(ps),' SR = ',num2str(SR),' tau = ',num2str(tau_tsvd), ' maxK= ',num2str(maxK)])
tic
im_t1 = mex_tSVD(single(N_Img),nSig,ps,maxK,SR,N_step,tau_tsvd);
time = toc;
PSNR  = csnr( O_Img, im_t1, 0, 0 );
im_ssim = cal_ssim(O_Img, im_t1,0,0);
SAM   = SpectAngMapper(O_Img, im_t1);
ERGAS = ErrRelGlobAdimSyn(O_Img, im_t1);
FSIM_MC = FeatureSIM(O_Img,im_t1);
fprintf( 'Estimated Image: time = %2.2f, nSig = %2.3f, PSNR = %2.2f , SSIM  = %2.3f, SAM = %2.4f , ERGAS  = %2.4f, FSIM_MC = %2.4f\n', time, nSig, PSNR , im_ssim, SAM, ERGAS, FSIM_MC);
