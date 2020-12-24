function par = Parset_LTDL(msi_sz)
%if you want to test the LTDL on cropped MSIs, please tune the redundancy
%ratio of dictionaries between 1.2-1.5, 
par.fatratio_D = [1.5,1.5]; %the redundancy ratio of dictionaries
par.nu = 1.05;
par.cS = 2;
par.cR = 1000;  %1000
par.delta = 0.2;
par.numDenoise = 2;
par.block_sz = [7 7];
par.overlap_sz = [5 5];
par.block_num = ceil((msi_sz(1:2) - par.overlap_sz)./(par.block_sz - par.overlap_sz));
par.remnum = rem(msi_sz(1:2) - par.overlap_sz,par.block_sz - par.overlap_sz);
% parameters for the algorithm
par.epsilon = 1e-4;
par.max_iter = 30;
par.rho = 1;
end