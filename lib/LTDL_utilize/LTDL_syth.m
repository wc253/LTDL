function [Z_group,Da,De,loss_list,Acc] = LTDL_syth(Da,De,nclusters,All_group,R,lamda1,lamda2,par,D1,D2)
%
% the optimization algorithm of proposed Low-rank Tensor Dictionary Learning (LTDL)
%
C_group = cell(1,nclusters);
YC_group = cell(1,nclusters);
T_group = cell(1,nclusters);
epsilon = par.epsilon;
max_iternum = par.max_iter;
rho = par.rho;
nu = par.nu;
loss_list = zeros(1,max_iternum);
Acc = zeros(1,max_iternum);
sizX = zeros(nclusters,3);
sizDa = size(Da,2);
sizDe = size(De,2);
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
    lastZD{kk} = tmprod(Z,{Da,De},[1,2]);
end
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
        %% Update C
        C_group{kk} = mysoft(Z-YC_group{kk}./rho,lamda1/rho,1); %l1 norm soft-thresholding
        
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
        Z3 = (s+tens2mat(rho*C_group{kk}+YC_group{kk},3))*invDI;
        Z = mat2tens(Z3, dimsZ, 3);
        Z_group{kk} = Z;
        
        %% Update Y
        YC_group{kk} = YC_group{kk}+rho*(C_group{kk}-Z_group{kk});
        
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
    X = [];
    A = [];
    for i = 1:nclusters
        XX = (tens2mat(All_group{i}+lamda2*T_group{i},2))/(1+lamda2);
        X = [X,XX];
        AA = tens2mat(tmprod(Z_group{i},{Da},[1]),2);
        A = [A,AA];
    end
    De = l2ls_learn_basis_dual(X, A, 1, De);
    clear XX X AA A 

    rho = rho*nu;
        %% Calculate the accuracy of matched atoms
    Acc(k) = matched_atoms(kron(De,Da),kron(D2,D1),0.01);
    loss = 0;
    err = 0;
    for i = 1:nclusters
        ZD{i} = tmprod(Z_group{i},{Da,De},[1,2]);
        err = err + frob(lastZD{i}-ZD{i})/frob(lastZD{i});
        loss_k = frob(ZD{i}-All_group{i})^2+lamda1*sum(abs(Z_group{i}(:)))+lamda2*frob(ZD{i}-T_group{i})^2;
        loss = loss + loss_k;
    end
    loss_list(k) = loss;
    lastZD = ZD;
    disp([sprintf('Ier: %.0f objective value=%.2f success recovery atoms=%.0f',k,loss_list(k),Acc(k))]);
    if err/nclusters < epsilon
       break
    end
end
end