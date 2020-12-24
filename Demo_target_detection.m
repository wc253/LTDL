clear;

%% load data
addpath(genpath('lib'));
load('data\jasperRidge_10band')
dataName = ['result\pre_jasperRidge_10band.mat']; % pre-computing results of 'Demo_denoise_v2' for MSI detection
load(dataName);
nRow = 100;
nCol = 100;

%% detect 'road' on denoised MSI via other methods
show_band = 8;
methodname{1}='Noisy image';
methodname{10}='MSt-SVD';

c = 1;
figure(1)
plot_m  = tight_subplot(2,6,[.05 .01],[.01 .05],[.01 .01]);
axes(plot_m(c));
axis off
axes(plot_m(c+6));

[~,idx] = find(gt==1);
imagesc(reshape(gt,[100,100]));axis image;
set(gca,'xticklabel',{ },'yticklabel',{ });
title('Ground truth','FontSize',16);
c = c+1;

for i = enList
    de_msi = Re_msi{i};
    de_M = (reshape(de_msi, [nRow*nCol, length(target)]))';
    r = hyperCem(de_M, target);
    outputs = (r-min(r))/(max(r)-min(r));
    outputs2D = reshape(outputs, [nRow, nCol]);
    outputs2D(outputs2D(:)>0.3)=1;
    outputs2D(outputs2D(:)<=0.3)=0;
    
    %% denoising results
    figure(1)
    axes(plot_m(c));
    imshow(de_msi(:,:,show_band));title(methodname{i},'FontSize',16);
    axes(plot_m(c+6));
    imagesc(outputs2D);axis image;
    set(gca,'xticklabel',{ },'yticklabel',{ });
    title(methodname{i},'FontSize',16);
    
    %% ROC
    [FPR,TPR] = myPlotROC(gt, outputs);
    figure(2);
    semilogx(FPR,TPR);
    xlabel('false alarm rate'); 
    ylabel('probability of detection');
    title('ROC curves');
    hold on;
    c = c+1;
end
legend(methodname{enList})
grid on