function [num] = matched_atoms(D,D0,err_atom)
sizD = size(D);
num = 0;
nu = sizD(2);
for j = 1:sizD(2)
    da = D(:,j)/(D(:,j)'*D(:,j));
    err_da = ones(nu,1) - abs(D0'*da); % calculate the error
    %err_da = acos(abs(D0'*da)./(da'*da)); % calculate the angle
    [min_da, p] = min(err_da);
    if min_da < err_atom %pi/9 
        D0(:,p) = [];
        num = num + 1;
        nu = nu - 1;
    end
end
end