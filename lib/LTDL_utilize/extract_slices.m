function [slices] = extract_slices(cur_msi,par,msi_sz)
%==========================================================================
% Extract full bands blocks of an MSI by window and unfold each block into slices at
% spectral domain. Three modes of slices refers to space, spectral and
% blocks.
%
% See also joint_slices
%==========================================================================

block_num = par.block_num;
block_sz = par.block_sz;
overlap_sz = par.overlap_sz;
remnum = par.remnum;
slices = zeros(prod(par.block_sz),msi_sz(3),prod(block_num));
for i = 1:block_num(1) 
    for j = 1:block_num(2) 
        ii = 1 + (i - 1)*(block_sz(1) - overlap_sz(1));
        jj = 1 + (j - 1)*(block_sz(2) - overlap_sz(2));
        idx = (j-1)*block_num(1) + i;
        if (ii+block_sz(1)-1) <= msi_sz(1) && (jj+block_sz(2)-1) <= msi_sz(2)
            slices(:, :, idx) = ...
                (tens2mat(cur_msi(ii:ii+block_sz(1)-1, jj:jj+block_sz(2)-1, :),3))';
        elseif jj+block_sz(2)-1 > msi_sz(2) && (ii+block_sz(1)-1) <= msi_sz(1)
             slices(:, :, idx) = ...
             (tens2mat(cur_msi(ii:ii+block_sz(1)-1, jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :),3))';
        elseif ii+block_sz(1)-1 > msi_sz(1) && (jj+block_sz(2)-1) <= msi_sz(2)
             slices(:, :, idx) = ...
             (tens2mat(cur_msi(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj:jj+block_sz(2)-1, :),3))';
        elseif ii+block_sz(1)-1 > msi_sz(1) && jj+block_sz(2)-1 > msi_sz(2)
             slices(:, :, idx) = ...
             (tens2mat(cur_msi(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :),3))';
        end 
    end
end
end