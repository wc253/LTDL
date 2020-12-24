function [] = get_img2re_crop_img(varargin)

opts.im_in_dir  = 'G:\My paper\2018TGRS--HSIDeNet--Hyperspectral Image Restoration via Deep Convolutional Nerual Network\TrainingCodes\HSIDeNet_Training\data\Train_Data300';
opts.im_out_dir = 'G:\My paper\2018TGRS--HSIDeNet--Hyperspectral Image Restoration via Deep Convolutional Nerual Network\TrainingCodes\HSI-GAN_Training\Data';
opts.img_format = 'mat';
opts.crop_size = 128;
opts = vl_argparse(opts, varargin);
count = 0;
if ~exist(opts.im_out_dir , 'dir'), mkdir(opts.im_out_dir) ; end

im_in_dir = dir(fullfile(opts.im_in_dir , ['*.', opts.img_format]));

for i = 1:1:numel(im_in_dir)
    load(fullfile(opts.im_in_dir, im_in_dir(i).name));
    im_tmp = x;
    for j = 1:8
        image_aug = data_augmentation(im_tmp, j);  % augment data
        for x = 1 : 40 : (180-40+1)
            for y = 1 :40 : (180-40+1)
                count       = count+1;
                temp = image_aug(x : x+40-1, y : y+40-1, :);
                save(strcat('Train_',num2str(count),'.mat'), 'temp');
            end
        end
        
    end
    if mod(i,1000)==0
        fprintf('%d images processed (%.3f Hz)\n', i, 1/toc)
    end
end

fprintf('get_img2re_crop_img is complete\n') ;

return;


