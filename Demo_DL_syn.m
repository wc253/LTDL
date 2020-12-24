% Test the proposed LTDL's dictionary learning performance with synthetic data (Fig. 4). 
% You can take about 0.5h to test once (or you can see the pre©\computed results in the road 
% of 'result\pre_synthetic_data_test_once')
clear; clc;
addpath(genpath('lib'));

%% experimental setting
nblocks = 15; %the number of blocks in each group
sizX = [10,10,nblocks]; % data size
nclusters = 300; % number of groups
ratio_D = 1.5; % fat ratio of dictionaries
sp_f = 5; % sparsity of the coefficient tensor on mode1 and mode2
Rank3 = 3; % rank of coefficient tensor(or data) on mode3, no more than sp_f
test_num = 1;  % test number, you can test multiple times to get an smooth curve
no = [0,0.1,0.2]; % different degrees of noise
L1 = [0.2,0.4,0.6]; L2 = [0.1,1,5];% fune tuned parameters of proposed method under different noises

%% generate groundtruth dictionaries, coefficient tensors and data
D1 = randn(sizX(1),ratio_D*sizX(1)); % groundtruth dictionaries
D2 = randn(sizX(2),ratio_D*sizX(2));
D1 = D1*diag(1./sqrt(sum(D1.*D1)));
D2 = D2*diag(1./sqrt(sum(D2.*D2)));
sizZ = [ratio_D*sizX(1),ratio_D*sizX(2),sizX(3)];
sZ_group = cell(1,nclusters);
X_group = cell(1,nclusters);
sp_idx = zeros(nclusters,sp_f);
for i = 1:nclusters
    A = randn(nblocks,Rank3); 
    Ax = randn(Rank3,sp_f);
    Z = zeros(sizZ);
    Z3 = tens2mat(Z,3);
    sp_idx(i,:) = randperm(sizZ(1)*sizZ(2),sp_f);
    Z3(:,sp_idx(i,:)) = A*Ax; % the non-zero fibers of coefficient tensor
    Z = mat2tens(Z3,sizZ,3);
    sZ_group{i} = Z; % coefficient tensor
    X = tmprod(sZ_group{i},{D1,D2},[1,2]);
    X_group{i} = X; % data
    for j = 1:3
        R(j,i) = rank(tens2mat(X,j));
    end
end

%% parameter settings for the algorithm
par.nu = 1;
par.epsilon = 1e-8;
par.max_iter = 200;
par.rho = 0.5;

Acc_kron = zeros(length(no),test_num,par.max_iter);
Acc_kron_wolr = zeros(length(no),test_num,par.max_iter);
Loss = zeros(length(no),test_num,par.max_iter);
Loss_wolr = zeros(length(no),test_num,par.max_iter);
for n = 1:length(no)
    %% add noise
    noX_group = cell(1,nclusters);
    for i = 1:nclusters
        noX_group{i} = X_group{i}+no(n)*randn(sizX);
    end
    lamda1   = L1(n);
    lamda2   = L2(n);
    for k = 1:test_num       
            rand('state',sum(clock)*rand(1));
            randn('state',sum(clock)*rand(1));  
            %% initialize dictionaries
            Da = randn(sizX(1),ratio_D*sizX(1));
            Db = randn(sizX(2),ratio_D*sizX(2));
            Da = Da*diag(1./sqrt(sum(Da.*Da)));
            Db = Db*diag(1./sqrt(sum(Db.*Db)));
            
            %% proposed method
            disp('Using the proposed LTDL')
            tic
            [~,~,~,loss,Acc] = LTDL_syth(Da,Db,nclusters,noX_group,R,lamda1,lamda2,par,D1,D2);
            time = toc;
            Acc_kron(n,k,:) = Acc;
            Loss(n,k,:) = loss;
            
            %% proposed method without lowrank
            disp('Using the proposed LTDL without lowrank')
            [~,~,~,loss,Acc] = LTDL_syth(Da,Db,nclusters,noX_group,R,0.2,0,par,D1,D2);
            Acc_kron_wolr(n,k,:) = Acc;
            Loss_wolr(n,k,:) = loss;            
    end
end
save('result\result_DL_synthetic_data');
col = char('r','g^','b');   
subplot(1,2,1)
for i = 1:length(no)
    mean_Acc_kron_wolr = squeeze(mean(Acc_kron_wolr(i,:,:),2))/225;
    plot(mean_Acc_kron_wolr,[':' col(i)],'LineWidth',2); hold on;
    mean_Acc_kron = squeeze(mean(Acc_kron(i,:,:),1))/225;
    plot(mean_Acc_kron,['-' col(i)],'LineWidth',2); hold on;
end
xlabel('iteration');
ylabel('success recovery ratio');
subplot(1,2,2)
for i = 1:length(no)
    mean_Loss = squeeze(mean(Loss(i,:,:),2));
    plot(mean_Loss,['-' col(i)],'LineWidth',2); hold on;
end
xlabel('iteration');
ylabel('objective function');