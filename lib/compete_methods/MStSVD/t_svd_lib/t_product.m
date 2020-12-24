function [A]=t_product(U,S,V)
size_S=size(S);N_pictures=size_S(end); length_S = length(size_S);

if(length_S==4)
    D=size_S(end-1);
elseif(length_S==3)
    D=size_S(end);
end
% A=zeros(size_S);
U_f=fft(U,[],3);V_f=fft(V,[],3);


for k=1:N_pictures
    S_f=fft(S(:,:,:,k),[],3);
    for i=1:D
        size(S_f(:,:,i))
        A(:,:,i,k)=U_f(:,:,i)*S_f(:,:,i)*V_f(:,:,i)';
    end
    A(:,:,:,k)=ifft(A(:,:,:,k),[],3);
end

end