function [ A_d ] = ffd( A,M )
%L_D Summary of this function goes here
%   Detailed explanation goes here
% [~,~,D] = size(A);
% C = dct(eye(D));
% Z = diag(ones(D-1,1),1);
% one_D = ones(D);
% I = diag(one_D(:,1));
% W = diag(C(:,1));
% M = inv(W)*C*(I+Z);
% M = rand(4,4);

A_d = my_ttm(A,M,3,'nt');

end

