%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% name: calc_curve.m
%
% This is sub-routine of SCORE algorithm to calculate modified eigenvalue estimator by using HOSVD core tensor, and calculate evaluation values of MDL(BIC).
%
% This code was implemented by T. Yokota
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mdl l2 rho v2] = calc_curve(H1,rho,ab);

[p L] = size(H1);

if L < p
  p  = L;
end

mu = sum(H1.^2,1)/p;
[mu IDD]= sort(mu,'descend');
lm = sum(H1.^2,2)/L;

L2 = max(1,round(rho*L)); %
v2 = mean(mu(L2:end));

[HS IDD] = sort((H1.^2)','descend');
l2 = sort(sum(HS(1:L2,:),1),'descend');
L2 = L;
%HS = zeros(p,L2); %
%for i = 1:L2      
%    HS(:,i) = H1(:,IDD(i));
%end

%l2 = sort(sum(HS.^2,2),'descend')/L2; %

for k = 1:(p-1)
  v  = mean(l2(k+1:p));

  if strcmp(ab,'bic')
    mdl(k,1) = -sum(log(l2(k+1:p))) + (p-k)*log(v) + k*(2*p-k)*log(L2)/L2/2;
  else
    mdl(k,1) = -sum(log(l2(k+1:p))) + (p-k)*log(v) + k*(2*p-k)/L2;
  end

end


