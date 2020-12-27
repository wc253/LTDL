clc;
clear;close all;
addpath(genpath('lib'));
randn('state', 2020)

%% Set enable bits
% apply on matrix data
EN_KSVD     = 0;
EN_BM3D     = 0;

% apply on tensor data
EN_LRTA     = 0;
EN_PARAFAC  = 0;
EN_BM4D     = 0;
EN_Tdl      = 0;
EN_KBRreg   = 1;
EN_LLRT     = 1;
EN_MStSVD   = 1;
EN_LTDL     = 1; % the proposed method
methodname ={'Nosiy MSI','KSVD','BM3D','LRTA','PARAFAC','BM4D','TDL','KBRreg','LLRT','MStSVD','LTDL','HSIDnet'};

%% Select the experiment
exp = 1; % 0-compared with deep learning method   1-denoise for target detection
if exp ==0
    sigma_ratio = 20/255; % Gaussian noise with 20/255 or 10/255
    dataName = ['data\HSIDnet_data.mat'];
    load(dataName);  % load test msi data compared with deep learning method
    noisy_msi = msi + sigma_ratio*randn(size(msi));
    EN_HSIDnet   = 1; % deep learning based method
    road= ['result\modeldrivenVSdatadriven'];
    iscleanmsi = 1;
elseif exp ==1
    dataName = ['data\jasperRidge_10band.mat'];
    load(dataName);  % load noisy jasperRidge2 for detection
    sigma_ratio = 0.01; % Gaussian noise
    EN_HSIDnet   = 0;
    road = ['result\re_jasperRidge'];  % save the recovered MSIs for detection
    iscleanmsi = 0;
end

%% Noisy msi
msi_sz = size(noisy_msi);
i = 1;
noisy_msi = double(noisy_msi);
sigma     = sigma_ratio;
Re_msi{i} = noisy_msi;
enList = 1;
if iscleanmsi == 1
    msi = double(msi);
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
end
    

%% Use KSVD
i = i+1;
if EN_KSVD
    bwksvd_params.blocksize = [8, 8];
    bwksvd_params.sigma = sigma;
    bwksvd_params.memusage = 'high';
    bwksvd_params.trainnum = 200;
    bwksvd_params.stepsize = [4, 4];
    bwksvd_params.maxval = 1;
    bwksvd_params.dictsize = 128;
    tic;
    for ch = 1:msi_sz(3)
        bwksvd_params.x = noisy_msi(:, :, ch);
        Re_msi{i}(:, :, ch) = ksvddenoise(bwksvd_params, 0);
    end
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end


%% Use BM3D
i = i+1;
if EN_BM3D
    tic;
    for ch = 1:msi_sz(3)
        [~, Re_msi{i}(:, :, ch)] = BM3D(1, noisy_msi(:, :, ch), sigma*255);
    end
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end


%% Use LRTA
i = i+1;
if EN_LRTA
    tic;
    Re_msi{i} = double(LRTA(tensor(noisy_msi)));
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end

%% Use PARAFAC
i = i+1;
if EN_PARAFAC
    tic;
    Re_msi{i}  = PARAFAC(tensor(noisy_msi));
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end

%% Use BM4D
i = i+1;
if EN_BM4D
    tic;
    [~, Re_msi{i}] = bm4d(1, noisy_msi, sigma);
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end

%% Use Tdl
i = i+1;
if EN_Tdl
    tic;
    vstbmtf_params.peak_value = 0;
    vstbmtf_params.nsigma = sigma;
    Re_msi{i} = TensorDL(noisy_msi, vstbmtf_params);
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end

%% Use KBRreg method
i = i+1;
if EN_KBRreg
    memorySaving = 1; % for KBRreg
    tic;
    Re_msi{i} = KBR_DeNoising(noisy_msi,sigma, memorySaving);%,Omsi);
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
    delete(gcp);
end

%% Use LLRT method
i = i+1;
if EN_LLRT
    tic;
    Par   = ParSet_LLRT(255*sigma);
    Re_msi{i} = LLRT_DeNoising( 255*noisy_msi, Par);
    Re_msi{i} = Re_msi{i}/255;
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end

%% Use MStSVD method
i = i+1;
if EN_MStSVD
    tic;
    Re_msi{i} = mex_tSVD(single(255*noisy_msi),255*sigma,8,30,16,4,4);
    Re_msi{i} = Re_msi{i}/255;
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end

%% Use LTDL method
i = i+1;
if EN_LTDL
    par = Parset_LTDL(msi_sz);
    tic;
    Re_msi{i} = LTDL_denoising(noisy_msi,sigma,par);
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end

%% Use HSIDnet method
i = i+1;
if EN_HSIDnet
    % please see 'Readme.txt' in the path 'lib\compete_methods\HSI-DeNet1'
    opts.idx_gpus = 0; 
    opts.matconvnet_path = 'D:\matlab\toolbox\matconvnet-1.0-beta25\matlab\vl_setupnn.m';  % To run the demos, you should first download and install [MatConvNet]
    opts.net_path = ['lib\compete_methods\HSI-DeNet1\Model\Sigma=' num2str(sigma_ratio*255) '_net.mat']; 

    opts = vl_argparse(opts, {});
    run(opts.matconvnet_path);

    % load network
    net = load(opts.net_path);
    net = net.net(1); % idx 1: Generator, 2: Discriminator
    net = dagnn.DagNN.loadobj(net);
    net.mode = 'test';
    
    tic
    net.eval({'input',single(noisy_msi)});
    im_out = gather(net.vars(net.getVarIndex('conv18')).value);
    Re_msi{i} = noisy_msi - double(im_out);
    Time(i) = toc;
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    if iscleanmsi == 1
        [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    	disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    end
    enList = [enList,i];
end

%% show all results
% save(road, 'enList','methodname','Re_msi','Time'); %,'msi'
num_fig = length(enList)+1;
plot_m  = tight_subplot(ceil(num_fig/6),6,[.05 .01],[.01 .05],[.01 .01]);
for n = 1:num_fig
    if n ==1 && iscleanmsi == 1
        axes(plot_m(n));
        imshow(msi(:,:,2));
        title('clean msi','FontSize',14);
    elseif n > 1
        axes(plot_m(n));
        imshow(Re_msi{enList(n-1)}(:,:,2));
        title(methodname{enList(n-1)},'FontSize',14);
    end
end
set(gcf,'unit','normalized','position',[0.2,0.05,0.6,0.85]);