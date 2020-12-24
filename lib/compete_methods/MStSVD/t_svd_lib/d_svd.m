function [ U,S,V ] = d_svd( A )

[A_d] = L_D(A);

for i = 1:D
    [U_d(:,:,i),S_d(:,:,i),V_d(:,:,i)] = svd(A_d(:,:,i));
end
U = invL_D(U_d);S = invL_D(S_d);V = invL_D(V_d);
end

