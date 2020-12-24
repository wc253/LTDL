function X=ClosedWL1(Y,C,oureps)
% solving the following problem
%         sum(log(SigmaY+oureps))+1/2*||Y-X||_F^2
% where oureps is a small constant
absY      = abs(Y);
signY     = sign(Y);
temp      = (absY-oureps).^2-4*(C-oureps*absY);
ind       = temp>0;
% svp       = sum(ind(:));
% absY      = absY.*ind;
absY      = (absY-oureps+sqrt(temp))/2.*ind;
X         = absY.*signY;
end