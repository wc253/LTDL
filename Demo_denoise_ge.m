clc;
clear;close all;
addpath(genpath('lib'));

%% load msi data
dataName = ['data\watercolors_MSI.mat'];
load(dataName);
methodname ={'Nosiy MSI','KSVD','BM3D','LRTA','PARAFAC','BM4D','TDL','KBRreg','LLRT','MStSVD','LTDL(ours)'};
msi = msi(150:400,150:400,:); % If you want to try the MSI of original size, please make sure you have enough computer memory (at least 16G).
msi_sz = size(msi);

%% Set enable bits
% apply on matrix data
EN_KSVD     = 1;
EN_BM3D     = 1;

% apply on tensor data
EN_LRTA     = 1;
EN_PARAFAC  = 1;
EN_BM4D     = 1;
EN_Tdl      = 1;
EN_KBRreg   = 1;
EN_LLRT     = 1;
EN_MStSVD   = 1;
EN_LTDL     = 1; % the proposed method
%% add noise
i = 1;
sigma_ratio = 0.20;  % Gaussian noise
noisy_msi = msi + sigma_ratio * randn(msi_sz);
sigma     = sigma_ratio;
Re_msi{i} = noisy_msi;
[psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
enList = 1;
disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])

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
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
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
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    enList = [enList,i];
end


%% Use LRTA
i = i+1;
if EN_LRTA
    tic;
    Re_msi{i} = double(LRTA(tensor(noisy_msi)));
    Time(i) = toc;
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    enList = [enList,i];
end

%% Use PARAFAC
i = i+1;
if EN_PARAFAC
    tic;
    Re_msi{i}  = PARAFAC(tensor(noisy_msi));
    Time(i) = toc;
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    enList = [enList,i];
end

%% Use BM4D
i = i+1;
if EN_BM4D
    tic;
    [~, Re_msi{i}] = bm4d(1, noisy_msi, sigma);
    Time(i) = toc;
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
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
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    enList = [enList,i];
end

%% Use KBRreg method
i = i+1;
if EN_KBRreg
    memorySaving = 1; % for KBRreg
    tic;
    Re_msi{i} = KBR_DeNoising(noisy_msi,sigma, memorySaving);%,Omsi);
    Time(i) = toc;
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
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
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    enList = [enList,i];
end

%% Use MStSVD method
i = i+1;
if EN_MStSVD
    tic;
    Re_msi{i} = mex_tSVD(single(255*noisy_msi),255*sigma,8,30,16,4,4);
    Re_msi{i} = Re_msi{i}/255;
    Time(i) = toc;
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    enList = [enList,i];
end

%% Use LTDL method
i = i+1;
if EN_LTDL
    par = Parset_LTDL(msi_sz);
    tic;
    Re_msi{i} = LTDL_denoising(noisy_msi,sigma,par);
    Time(i) = toc;
    [psnr(i), ssim(i), fsim(i), ergas(i), sam(i)] = MSIQA(msi * 255, Re_msi{i} * 255);
    disp([methodname{i}, ' done in ' num2str(Time(i)), ' s.'])
    disp([sprintf('%s: PSNR=%.2f SSIM=%.2f ERGAS=%.2f SAM=%.2f.',methodname{i},psnr(i),ssim(i),ergas(i),sam(i))])
    enList = [enList,i];
end

%% show all results
plot_m  = tight_subplot(3,4,[.05 .01],[.01 .05],[.01 .01]);
for n = 1:12
    axes(plot_m(n));
    if n ==1
        imshow(msi(:,:,[31,11,6]));
        title(['Clean'],'FontSize',14);
    else
        if (~isempty(Re_msi{n-1}))
        imshow(Re_msi{n-1}(:,:,[31,11,6]));
        end
        title([methodname{n-1} ' PSNR=' num2str(psnr(n-1),4) 'dB'],'FontSize',14);
    end
end
set(gcf,'unit','normalized','position',[0.2,0.05,0.6,0.85]);
road = ['result\re_watercolors_MSI'];
save(road, 'msi','psnr','ssim','fsim','ergas','sam','methodname','Re_msi','Time');