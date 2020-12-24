
function [ net ] = get_test_ms(varargin)
addpath(genpath('src\'));
% cpu and gpu settings 
opts.idx_gpus = 1; % 0: cpu
opts.num_images = 32; % images to be generated
opts.matconvnet_path = 'matconvnet-1.0-beta24/matlab/vl_setupnn.m';
opts.net_path = 'Model/Sigma=20.mat'; 

opts = vl_argparse(opts, varargin);
run(opts.matconvnet_path);
sigma = 20;
stripe_max = 0;
stripe_min = -0;

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
load('Testdata\sample.mat');
data = single(x);
randn('seed',0);
rand('seed',0);
stripe_mat  = single(repmat((stripe_max - stripe_min).*rand(1,size(data,2)*size(data,3)) + stripe_min,size(data,1),1)/255);
stripe_cub  = reshape(stripe_mat,size(data,1),size(data,2),size(data,3));
noise = data + single(sigma/255*randn(size(data))) + stripe_cub;
if opts.idx_gpus >0,   noise = gpuArray(noise);    end

net.eval({'input',noise});
im_out = gather(net.vars(net.getVarIndex('conv18')).value);
if opts.idx_gpus
    im_out = gather(im_out);
    noise  = gather(noise);
end
output = noise - im_out;
PSNR_CNN  =  csnr( 256*(data), double(256*(output)), 0, 0 );
SSIM_CNN  =  cal_ssim( 256*(data), double(256*(output)), 0, 0 );
SAM_CNN   = SpectAngMapper(256*(data), double(256*(output)));
ERGAS_CNN = ErrRelGlobAdimSyn(256*(data), double(256*(output)));
figure,imshow([noise(:,:,5),output(:,:,5)])
fprintf( sprintf('%s : PSNR = %2.2f  SSIM = %2.4f SAM = %2.4f ERGAS = %2.4f \n', 'TestHSI', PSNR_CNN, SSIM_CNN, SAM_CNN, ERGAS_CNN) );
% fprintf('get_test_HSI restoration is complete\n');

