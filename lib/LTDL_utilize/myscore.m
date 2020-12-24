%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% name: score.m
%
% SCORE estimates multilinear tensor rank of a tensor Z using the HOSVD core tensor and MDL(BIC).
% rho : is a N-dimensional vector that each entry is a parameter (0 < rho(n) < 1).
%
% This code was implemented by T. Yokota
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [R] = myscore(Z)

  II = size(Z);
  N  = length(II);
  rho= [0.001 0.001 0.001];

  for n = 1:N
    Zn = tens2mat(Z,n);
    %Zn = double(tenmat(Z,n));
    [U{n} d v] = svd(double(Zn*Zn'));
  end
  S = tmprod(Z,{U{1}',U{2}',U{3}'},[1 2 3]);
  %S = ttm(Z,{U{1}',U{2}',U{3}'},[1 2 3]);
  for n = 1:3
    Sn = tens2mat(S,n);
    %Sn = double(tenmat(S,n));
    [mdl l2 rho2 v2] = calc_curve(Sn,rho(n),'bic');
    [val R(n)]= min(mdl);
    %Ur{n} = U{n}(:,1:R(n));
    %curves{n} = mdl;
  end
  %Sr = S(1:R(1),1:R(2),1:R(3));
  %Zest = tensor_allprod(Sr,Ur,0);
  %Zest = ttm(Sr,Ur,[1 2 3]);
end

