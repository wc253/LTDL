function [cur_msi] = joint_slices(slices,par,msi_sz)
%==========================================================================
% Fold each block into block at spectral domain and reconstruct the msi
% through blocks.
%
% See also extract_slices
%==========================================================================
block_num = par.block_num;
block_sz = par.block_sz;
overlap_sz = par.overlap_sz;
remnum = par.remnum;
mult = zeros(msi_sz);
cur_msi = zeros(msi_sz);
for i = 1:block_num(1)
    for j = 1:block_num(2)
        ii = 1 + (i - 1)*(block_sz(1) - overlap_sz(1));
        jj = 1 + (j - 1)*(block_sz(2) - overlap_sz(2));
        idx = (j-1)*block_num(1) + i;
        block =  mat2tens((slices(:,:,idx))',[block_sz,msi_sz(3)],3);
        if (ii+block_sz(1)-1) <= msi_sz(1) && (jj+block_sz(2)-1) <= msi_sz(2)
            mult(ii:ii+block_sz(1)-1, jj:jj+block_sz(2)-1, :) = ...
                mult(ii:ii+block_sz(1)-1, jj:jj+block_sz(2)-1, :) + 1;
            cur_msi(ii:ii+block_sz(1)-1, jj:jj+block_sz(2)-1, :) = ...
                cur_msi(ii:ii+block_sz(1)-1, jj:jj+block_sz(2)-1, :) + block;
        elseif jj+block_sz(2)-1 > msi_sz(2) && (ii+block_sz(1)-1) <= msi_sz(1)
            mult(ii:ii+block_sz(1)-1, jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :) = ...
                mult(ii:ii+block_sz(1)-1, jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :) + 1;
            cur_msi(ii:ii+block_sz(1)-1, jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :) = ...
                cur_msi(ii:ii+block_sz(1)-1, jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :) + block;
        elseif ii+block_sz(1)-1 > msi_sz(1) && (jj+block_sz(2)-1) <= msi_sz(2)
            mult(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj:jj+block_sz(2)-1, :) = ...
                mult(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj:jj+block_sz(2)-1, :) + 1;
            cur_msi(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj:jj+block_sz(2)-1, :) = ...
                cur_msi(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj:jj+block_sz(2)-1, :) + block;
        elseif ii+block_sz(1)-1 > msi_sz(1) && jj+block_sz(2)-1 > msi_sz(2)
            mult(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :) = ...
                mult(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :) + 1;
            cur_msi(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :) = ...
                cur_msi(ii - (block_sz(1) - overlap_sz(1) - remnum(1)):msi_sz(1), jj - (block_sz(2) - overlap_sz(2) - remnum(2)):msi_sz(2), :) + block;
        end
    end
end
cur_msi = cur_msi./mult;
cur_msi = cur_msi(1:msi_sz(1),1:msi_sz(2),:);
end