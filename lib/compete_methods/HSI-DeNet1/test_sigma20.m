% Test HSI-Denet on CAVE
% 255*sigma = 20
% clear;
close all;
addpath(genpath('src/'));
addpath(genpath('utilities/'));
% cpu and gpu settings
opts.idx_gpus = 0; % 0: cpu 1:gpu
% opts.num_images = 32; % images to be generated
opts.matconvnet_path = 'D:\matlab\bin\matconvnet-1.0-beta25\matlab\vl_setupnn.m';
opts.net_path = 'Model/Sigma=20.mat';
opts = vl_argparse(opts, cell(0,0));
run(opts.matconvnet_path);


%% load network
net = load(opts.net_path);
net = net.net(1); % idx 1: Generator, 2: Discriminator
net = dagnn.DagNN.loadobj(net);
net.mode = 'test';
if opts.idx_gpus >0
    %     gpuDevice()
    net.move('gpu');
end
rng('default')
randn('seed',0);
rand('seed',0);

dataPath = ['E:\gong\CVPR_model\msidata_m\sigma20\'];

for i = 1:32
    %% load msi data
    load([dataPath num2str(i)]);
    ini_band = [1,11,21];
    Re_msi_HSID = zeros(msi_sz);
    for b = 1:3
        bands = ini_band(b):(ini_band(b)+9);
        noise = noisy_msi(:,:,bands);
        if opts.idx_gpus >0,   noise = gpuArray(noise);    end
        
        net.eval({'input',noise});
        im_out = gather(net.vars(net.getVarIndex('conv18')).value);
        if opts.idx_gpus
            im_out = gather(im_out);
            noise  = gather(noise);
        end
        Re_msi_HSID(:,:,bands) = noise - im_out;
        MSIQA(msi(:,:,bands) * 255, Re_msi_HSID(:,:,bands) * 255)
    end
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi(:,:,1:30) * 255, Re_msi_HSID(:,:,1:30) * 255);
    fprintf( sprintf('%s : PSNR = %2.2f  SSIM = %2.4f SAM = %2.4f ERGAS = %2.4f \n', 'TestHSI', psnr(i), ssim(i), sam(i), ergas(i)) );
end