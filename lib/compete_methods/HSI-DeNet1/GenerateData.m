
%%% Generate the training data.

clear;close all;

addpath(genpath('./.'));
%addpath utilities;

batchSize      = 128;        %%% batch size
max_numPatches = batchSize*2000; 
modelName      = 'model_HSI_MixedNoise';
sigma          = 20;         %%% Gaussian noise level
stripe_min     = -0;        %%% min value
stripe_max     = 0;         %%% max value

%%% training and testing
folder_train  = 'Train_Data350'; %%% training
folder_test   = 'Test_Data350'; %%% testing
size_input    = 40;          %%% training
size_label    = 40;          %%% testing
stride_train  = 40;          %%% training
stride_test   = 80;          %%% testing
val_train     = 0;           %%% training % default
val_test      = 1;           %%% testing  % default

%%% training patches
[inputs, labels, set]  = patches_generation(sigma,stripe_min, stripe_max, size_input,size_label,stride_train,folder_train,val_train,max_numPatches,batchSize);
%%% testing  patches
[inputs2,labels2,set2] = patches_generation(sigma,stripe_min, stripe_max, size_input,size_label,stride_test,folder_test,val_test,max_numPatches,batchSize);

inputs   = cat(4,inputs,inputs2);      clear inputs2;
labels   = cat(4,labels,labels2);      clear labels2;
set      = cat(2,set,set2);            clear set2;

if ~exist(modelName,'file')
    mkdir(modelName);
end

%%% save data
save(fullfile(modelName,'imdb'), 'inputs','labels','set','-v7.3')

