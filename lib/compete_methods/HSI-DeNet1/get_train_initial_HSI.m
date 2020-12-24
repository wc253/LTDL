function [ net ] = get_train_initial_HSI(varargin)
addpath('src');
opts.matconvnet_path = 'matconvnet-1.0-beta24/matlab/vl_setupnn.m';

opts.idx_gpus = 1; % cpu/gpu settings 
opts.imdb_img_size = [40 40];

opts = vl_argparse(opts, varargin) ;
run(opts.matconvnet_path) ;

%% imdb settings 
imdb = load('H:\My Paper\2018TGRS--HSIDeNet--Hyperspectral Image Restoration via Deep Convolutional Nerual Network\TrainingCodes\HSIDeNet_Training\data\model_HSI_MixedNoise_R20S20\imdb.mat');
% You need to perform the GenerateData.m to generate the imdb.mat file

%% net settings 
opts.train.continue = true;
opts.train.solver = @solver.adam; % Empty array - optimised by adam solver
opts.train.expDir = fullfile(mfilename) ;
% opts.train.learningRate = learning_rate_policy(0.001, 15, 0.1, 0.0001, 100);
opts.train.learningRate = learning_rate_policy(0.0005, 20, 0.5, 0.00005, 100);
% opts.train.learningRate = learning_rate_policy(0.0001, 300, 0.1, 0.00001, 300);
opts.train.numEpochs = numel(opts.train.learningRate); 
opts.train.batchSize = 128;
opts.train.weightDecay = 0;
opts.train.derOutputsG = {'Loss', 1};
opts.train.gpus = opts.idx_gpus;
if opts.train.gpus == 0
    opts.train.gpus = [];
end

opts = vl_argparse(opts, varargin) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% G feature extration
%% U-Net
netG = dagnn.DagNN();
i = 1;

inputs  = { 'input' };
outputs = { sprintf('conv%d', i) };
params  = { sprintf('conv%d_f', i), ...
    sprintf('conv%d_b', i)};
netG.addLayer(outputs{1},  dagnn.Conv('size',[3 3 10 64], 'pad',1, 'stride',1, 'hasBias',true), inputs, outputs,  params);  
idx = netG.getParamIndex(params{1});
netG.params(idx).value         = sqrt(2/(9*64))*randn(3,3,10,64,'single');
netG.params(idx).learningRate  = 1;
netG.params(idx).weightDecay   = 1;

idx = netG.getParamIndex(params{2});
netG.params(idx).value         = zeros(64,1,'single');
netG.params(idx).learningRate  = 1;
netG.params(idx).weightDecay   = 0;


i = i + 1;
inputs  = { sprintf('conv%d', i-1)};
outputs = { sprintf('relu%d', i-1) };
netG.addLayer(outputs{1}, ...
    dagnn.ReLU('leak', 0.0), ...
    inputs, outputs);
next_input = sprintf('relu%d',i-1);

sigma = sqrt(2/(9*64));
epsilon = 1e-5;

[netG, i, next_input] = get_Block_CBR_V1( netG, i,  64, 64, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  64, 64, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  64, 64, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  64, 128, 3, 1, sigma, epsilon, next_input);
% [netG, i, next_input] = get_Block_CBR_V1( netG, i,  128, 128, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  128, 128, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  128, 128, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  128, 256, 3, 1, sigma, epsilon, next_input);
% [netG, i, next_input] = get_Block_CBR_V1( netG, i,  256, 256, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  256, 256, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  256, 256, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  256, 128, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  128, 128, 3, 1, sigma, epsilon, next_input);
% [netG, i, next_input] = get_Block_CBR_V1( netG, i,  128, 128, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  128, 128, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  128, 64, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  64, 64, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  64, 64, 3, 1, sigma, epsilon, next_input);
[netG, i, next_input] = get_Block_CBR_V1( netG, i,  64, 64, 3, 1, sigma, epsilon, next_input);

inputs  = { next_input };
outputs = { sprintf('conv%d', i) };
params  = { sprintf('conv%d_f', i), ...
    sprintf('conv%d_b', i)};
netG.addLayer(outputs{1},  dagnn.Conv('size',[3 3 64 10], 'pad',1, 'stride',1, 'hasBias',true), inputs, outputs,  params);  
idx = netG.getParamIndex(params{1});
netG.params(idx).value         = sqrt(2/(9*64))*randn(3,3,64,10,'single');
netG.params(idx).learningRate  = 1;
netG.params(idx).weightDecay   = 1;

idx = netG.getParamIndex(params{2});
netG.params(idx).value         = zeros(10,1,'single');
netG.params(idx).learningRate  = 1;
netG.params(idx).weightDecay   = 0;

netG.addLayer('Loss', dagnn.vllab_dag_loss('loss_type', 'L2'),{ outputs{1},'data'}, 'Loss');

% netG.initParams();
netG.meta.trainOpts = opts.train;

net = [netG];

% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------
[net, ~] = cnn_train_dag_ms(net, imdb, @getBatch, opts.train, ...
                                       'val', find(imdb.set == 2)) ; 
return;

%%%-------------------------------------------------------------------------

%%%-------------------------------------------------------------------------
function [inputs,labels] = getBatch(imdb, batch)
%%%-------------------------------------------------------------------------
inputs = imdb.inputs(:,:,:,batch);
labels = imdb.labels(:,:,:,batch);

