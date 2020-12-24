function [deno_msi] = LTDL_denoising(noisy_msi,sigma,par)
msi_sz = size(noisy_msi);
deno_msi = noisy_msi;
sizDa = [prod(par.block_sz),floor(par.fatratio_D(1)*prod(par.block_sz))];
sizDe = [msi_sz(3),floor(par.fatratio_D(2)*msi_sz(3))];
for ii = 1:par.numDenoise
    nomcur_msi = deno_msi + par.delta*(noisy_msi - deno_msi);
    %% form all tensor groups
    noimsi_slices = extract_slices(nomcur_msi,par,msi_sz);
    X = reshape(noimsi_slices, prod(par.block_sz)*msi_sz(3), size(noimsi_slices, 3))';
    mean_blocks = 100;
    nclusters = ceil(prod(par.block_num)/(mean_blocks));
    fkmeans_opt.careful = 1;
    [idx,nclusters,~,~] = myfkmeans(X, nclusters, fkmeans_opt); % kmeans++
    Nblocks = zeros(1,nclusters);
    All_group = cell(1,nclusters);
    origi_All_group = cell(1,nclusters);
    %% initialization of dictionries
    Da = randn(sizDa); %
    De = randn(sizDe);
    Da = Da*diag(1./sqrt(sum(Da.*Da)));
    De = De*diag(1./sqrt(sum(De.*De)));
    
    if(ii == 1)
        origi_noimsi_slices = noimsi_slices;
        lamdaS   = par.cS*sigma; % sparsity weight
        lamdaR   = par.cR*sigma; % low-rank weight
        for k = 1:nclusters
            nblocks = numel(find(idx==k));
            Nblocks(k) = nblocks;
            All_group{k} = noimsi_slices(:, :, idx==k);
            origi_All_group{k} = origi_noimsi_slices(:, :, idx==k);
        end
    else 
        A = (noisy_msi - deno_msi).^2;
        sigma_est   = sqrt(abs(sigma^2- mean(A(:)))); % estimate noise degree
        lamdaS   = par.cS*sigma_est;
        lamdaR   = par.cR*sigma_est;
%         par.max_iter = max(par.max_iter-10, 30);
        for k = 1:nclusters
            origi_All_group{k} = origi_noimsi_slices(:, :, idx==k);
            nblocks = numel(find(idx==k));
            Nblocks(k) = nblocks;
            All_group{k} = noimsi_slices(:, :, idx==k);
        end
    end
    clear X
    
    %% training Da,De and Z^(k) for all tensor groups
    R = setR(origi_All_group,nclusters);
    [Z_group,Da,De,~,~] = LTDL(Da,De,nclusters,All_group,R,lamdaS,lamdaR,par);
    %% reconstruct denoised MSI
    clean_slices = zeros(prod(par.block_sz),msi_sz(3),prod(par.block_num));
    for k = 1:nclusters
        clean_slices(:,:,idx==k) = tmprod(Z_group{k},{Da,De},[1 2]);
    end
    deno_msi = joint_slices(clean_slices,par,msi_sz);
    clear All_group idx clean_slices Z_group
end
end