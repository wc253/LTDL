function [ A ] = iffd(A_d,inv_M)
%L_D Summary of this function goes here
%   Detailed explanation goes here
% [~,~,D] = size(A_d);
% C = dct(eye(D));
% Z = diag(ones(D-1,1),1);
% one_D = ones(D);
% I = diag(one_D(:,1));
% W = diag(C(:,1));
% M = inv(W)*C*(I+Z);

A = my_ttm(A_d,inv_M,3,'nt');

end

