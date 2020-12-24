function [U,S,V] = t_svd(A)
%T_SVD Summary of this function goes here
%   Detailed explanation goes here

[~,~,D]=size(A);

% if(strcmp(select,'full')==1)
%      U=zeros(H,H,D);S=zeros(H,W,D);V=zeros(W,W,D);
%     A=fft(A,[],3);
%     for i=1:D
%         [Ui,Si,Vi]=svd(A(:,:,i));
%         U(:,:,i)=Ui;S(:,:,i)=Si;V(:,:,i)=Vi;
%     end
%     
%     U=ifft(U,[],3);S=ifft(S,[],3);V=ifft(V,[],3);
%     A=ifft(A,[],3);
%     
% elseif(strcmp(select,'cut')==1)
%     A=fft(A,[],3);
%     for i=1:D
%         [Ui,Si,Vi]=svd(A(:,:,i));
%         ss=diag(Si);[~,index]=sort(ss,'descend');
%         U(:,:,i)=Ui(:,index(1:R));S(:,:,i)=Si(index(1:R),index(1:R));V(:,:,i)=Vi(:,index(1:R));
%     end
%     U=ifft(U,[],3);S=ifft(S,[],3);V=ifft(V,[],3);
%     A=ifft(A,[],3);
% end


A=fft(A,[],3);

for i=1:D
    [Ui,Si,Vi]=svd(A(:,:,i));
    ss=diag(Si);[~,index]=sort(ss,'descend');
    U(:,:,i)=Ui;S(:,:,i)=Si;V(:,:,i)=Vi;
end
U=ifft(U,[],3);S=ifft(S,[],3);V=ifft(V,[],3);

% A=ifft(A,[],3);
% 
% A2=t_product(U,S,V);
% error=norm(A(:)-A2(:),'fro');


end


function [A]=t_product(U,S,V)
size_S=size(S);D=size_S(end);

U_f=fft(U,[],3);V_f=fft(V,[],3);S_f=fft(S,[],3);

for i=1:D
    A(:,:,i)=U_f(:,:,i)*S_f(:,:,i)*V_f(:,:,i)';
end

A=ifft(A,[],3);

end

