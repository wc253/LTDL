function [similarity_indices,count ] = search_cube_new(H,W,D,mat_im1,SR,ps,maxK,i,j,k )
%SEARCH_CUBE 此处显示有关此函数的摘要
%   此处显示详细说明

% [H,W,D] = size(im1);
info_ref = [i,j,k,ps,H,W];info_ref = int32(info_ref);
% info_all = [ps,H,W];info_all = int32(info_all);


% v_refpatch = search_cube_one(mat_im1,info_ref);

% ref_patch = im1(i:i+ps1-1,j:j+ps2-1,k:k+ps3-1);
% ref_patch = my_tenmat(ref_patch,2);
% v_refpatch = ref_patch(:);

sr_top = max([i-SR 1]);
sr_left = max([j-SR 1]);
sr_backward = max([k-SR 1]);
sr_right = min([j+SR W-ps+1]);
sr_bottom = min([i+SR H-ps+1]);
sr_forward = min([k+SR D-ps+1]);
range = [sr_top,sr_bottom,sr_left,sr_right,sr_backward,sr_forward];range = int32(range);

count = (sr_bottom-sr_top+1) * (sr_right-sr_left+1) * (sr_forward-sr_backward+1);

% 
% [C,similarity_indices] = search_cube_all(mat_im1,info_all,range);
% 
% rep_refpatch = repmat(v_refpatch,1,count);
% 
% distvals = sum((C - rep_refpatch).^2,1);

[C,similarity_indices] = search_cube_all_new(mat_im1,info_ref,range);

distvals = sum(C,1);


similarity_indices = similarity_indices';



if count > maxK
    [~,sortedindices] = sort(distvals,'ascend');
    similarity_indices = similarity_indices(sortedindices(1:maxK),:);
    count = maxK;
end


end

