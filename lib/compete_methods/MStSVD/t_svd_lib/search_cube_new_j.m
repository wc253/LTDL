function [similarity_indices,count ] = search_cube_new_j(H,W,i,j,k,mat_im1,ps,maxK,C,similarity_indices,count_this)
%SEARCH_CUBE 此处显示有关此函数的摘要
%   此处显示详细说明

%% this is for search_cube_all_j
% info_ref = [i,j,k,ps,H,W];info_ref = int32(info_ref);
% 
% v_refpatch = search_cube_one(mat_im1,info_ref);
% 
% rep_refpatch = repmat(v_refpatch,1,count_this);
% 
% distvals = sum((C - rep_refpatch).^2,1);
% similarity_indices = similarity_indices';
% 
% if count_this > maxK
%     [~,sortedindices] = sort(distvals,'ascend');
%     similarity_indices = similarity_indices(sortedindices(1:maxK),:);
%     count = maxK;
% end

%% this is for search_cube_all_j_new
similarity_indices = similarity_indices';
if count_this > maxK
    [~,sortedindices] = sort(distvals,'ascend');
    similarity_indices = similarity_indices(sortedindices(1:maxK),:);
    count = maxK;
end

end

