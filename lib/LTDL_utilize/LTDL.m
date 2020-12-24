function [Z_group,Da,De,errList,loss_list] = LTDL(Da,De,nclusters,All_group,R,lamda1,lamda2,par)
%
% the optimization algorithm of proposed Low-rank Tensor Dictionary Learning (LTDL)
%
YC_group = cell(1,nclusters);
T_group = cell(1,nclusters);
epsilon = par.epsilon;
max_iternum = par.max_iter;
rho = par.rho;
nu = par.nu;
errList = zeros(max_iternum, 1);
sizX = zeros(nclusters,3);
sizDa = size(Da,2);
sizDe = size(De,2);
loss_list = [];
%% initialize Z
Z_group = cell(1,nclusters);
D = (kron(De,Da))';
invD = pinv(D*D');
lastZD = cell(1,nclusters);
for kk = 1:nclusters
    X = All_group{kk};
    sizX(kk,:) = size(X);
    X3 = tens2mat(X,3);
    Z3 = (X3*D')*invD;
    Z = mat2tens(Z3,[sizDa sizDe sizX(kk,3)],3);
    Z_group{kk} = Z;
    YC_group{kk} = zeros([sizDa sizDe sizX(kk,3)]);
    lastZD{kk} = tmprod(Z_group{kk},{Da,De},[1,2]);
end
fprintf('iter£º         ')
for k = 1:max_iternum
    %fprintf('Inter:%f \n',k);
    ZD = cell(1,nclusters);
    D = (kron(De,Da))';
    d = size(D);
    [Uspa,Sspa,~] = svd(Da'*Da);
    [Uspe,Sspe,~] = svd(De'*De);
    kU=kron(Uspe,Uspa);
    kS=kron(sum(Sspe),sum(Sspa));
    invDI = kU*diag(1./((2+2*lamda2)*kS+rho*ones(1,d(1))))*kU';
    for kk = 1:nclusters
        Z = Z_group{kk};
        X = All_group{kk};
        YC_kk = YC_group{kk};
        %% Update C
        C_kk = mysoft(Z-YC_kk./rho,lamda1/rho,1); %l1 norm soft-thresholding
        
        %% Update T (hosvd or hooi)
%         T = double(hosvd(tensor(tmprod(Z,{Da,De},[1,2])),1e-3,'ranks',(R(:,kk))'));
        T = hosvd1(tmprod(Z,{Da,De},[1,2]),(R(:,kk))');
        T_group{kk} = T;
        %         Tu = tucker_als(tensor(tmprod(Z,{Da,De},[1,2])),(R(:,kk))','tol',1e-1,'printitn',0); %hooi
        %         T = tmprod(double(Tu.core),Tu.U,[1,2,3]);
        %         T_group{kk}  = T;
        
        %% Update Z
        dimsZ = [sizDa sizDe sizX(kk,3)];
        s = (tens2mat(2*X+2*lamda2*T,3))*D';
        Z3 = (s+tens2mat(rho*C_kk+YC_kk,3))*invDI;
        Z = mat2tens(Z3, dimsZ, 3);
        Z_group{kk} = Z;
        
        %% Update Y
        YC_group{kk} = YC_kk+rho*(C_kk-Z);
    end
    clear D kU s Z3 Z T Tu;
    %% Update Da and De
    X = [];
    A = [];
    for i = 1:nclusters
        XX = (tens2mat(All_group{i}+lamda2*T_group{i},1))/(1+lamda2);
        X = [X,XX];
        AA = tens2mat(tmprod(Z_group{i},{De},[2]),1);
        A = [A,AA];
    end
    Da = l2ls_learn_basis_dual(X, A, 1, Da);
%     Da = I_clearDictionary(Da,A,X);
    X = [];
    A = [];
    for i = 1:nclusters
        XX = (tens2mat(All_group{i}+lamda2*T_group{i},2))/(1+lamda2);
        X = [X,XX];
        AA = tens2mat(tmprod(Z_group{i},{Da},[1]),2);
        A = [A,AA];
    end
    De = l2ls_learn_basis_dual(X, A, 1, De);
%     De = I_clearDictionary(De,A,X);
    clear XX X AA A
    
    rho = rho*nu;
    
    %% show result with itration
%     I = displayDictionaryElementsAsImage(Da, 8, floor(sizDa/8),par.block_sz(1),par.block_sz(2));
%     imshow(I)
%     loss = 0;
%     for i = 1:nclusters
%         ZD{i} = tmprod(Z_group{i},{Da,De},[1,2]);
%         errList(k) = errList(k) + frob(lastZD{i}-ZD{i})/frob(lastZD{i});
%         loss_k = frob(ZD{i}-All_group{i})^2+lamda1*sum(abs(Z_group{i}(:)))+lamda2*frob(ZD{i}-T_group{i})^2;
%         loss = loss + loss_k;
%     end
%     loss_list(k) = loss;
%     errList(k) = errList(k)/nclusters;
%     lastZD = ZD;
%     disp([sprintf('Ier: %.1f error=%.4f loss=%.2f',k,errList(k),loss)]);
%     if errList(k) < epsilon
%         break
%     end
    fprintf('\b\b\b\b\b%5i',k);
end
fprintf('\n');
end

% function Dictionary = I_clearDictionary(Dictionary,CoefMatrix,Data)      
% % delete the correlated columns (atoms) in the dictionary and replace them with the data
% T2 = 0.99;
% T1 = 3;
% K=size(Dictionary,2);   
% Er=sum((Data-Dictionary*CoefMatrix).^2,1); %remove identical atoms
% G=Dictionary'*Dictionary;
% G = G-diag(diag(G));
% max(G(:))
% for jj=1:1:K
%     if max(G(jj,:))>T2 || length(find(abs(CoefMatrix(jj,:))>1e-7))<=T1 
%         [val,pos]=max(Er);     
%         Er(pos(1))=0;
%         Dictionary(:,jj)=Data(:,pos(1))/norm(Data(:,pos(1)));
%         G=Dictionary'*Dictionary; G = G-diag(diag(G));
%     end
% end
% end