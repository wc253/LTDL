% 生成统一的数据
clc;
clear;close all;
addpath(genpath('lib'));
dataPath = ['E:\gong\CVPR_model\msidata_m\sigma1_m\'];
sigma_ratio = 20/255;  % Gaussian noise
sigma     = sigma_ratio;
randn('seed',0);
rand('seed',0);
for i = 1:32
    %% load msi data
    load([dataPath num2str(i)]);
    msi = single(msi);
    msi_sz = size(msi);
    noisy_msi = msi +single(sigma*randn(msi_sz));
%     [psnr, ssim, fsim, ergas, sam] = MSIQA(msi * 255, noisy_msi * 255);
    save(['E:\gong\CVPR_model\msidata_m\sigma20\' num2str(i)])
end