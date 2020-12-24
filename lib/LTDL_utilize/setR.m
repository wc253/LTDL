function [R] = setR(All_group,nclusters)
R = zeros(3,nclusters);
% for msi denoising with Gaussian noises
for k = 1:nclusters
    X = All_group{k};
    R(:,k) = myscore(X);
end
end