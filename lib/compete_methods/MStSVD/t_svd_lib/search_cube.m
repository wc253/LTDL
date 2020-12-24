function [ similarity_indices,count ] = search_cube( im1,SR,ps,maxK,i,j,k )
%SEARCH_CUBE 此处显示有关此函数的摘要
%   此处显示详细说明
[H,W,D] = size(im1);
ps1 = ps(1);ps2 = ps(1);ps3 = ps(1);
refpatch = im1(i:i+ps1-1,j:j+ps2-1,k:k+ps3-1);% note that j increase by one.
v_refpatch = refpatch(:);

sr_top = max([i-SR 1]);
sr_left = max([j-SR 1]);
sr_backward = max([k-SR 1]);
sr_right = min([j+SR W-ps1+1]);
sr_bottom = min([i+SR H-ps2+1]);
sr_forward = min([k+SR D-ps3+1]);
range = [sr_top,sr_bottom,sr_left,sr_right,sr_forward,sr_backward];range = int32(range);

similarity_indices = zeros((2*SR+1)^3,3);
distvals = similarity_indices(:,1); %distance value of refpatch and each target patch.
count  = 0;
for i1=sr_top:sr_bottom
    for j1=sr_left:sr_right
        for k1 = sr_backward:sr_forward
            info = [i1,j1,k1,ps1,H,W];
            currpatch = im1(i1:i1+ps1-1,j1:j1+ps2-1,k1:k1+ps3-1); %current patch
%             currpatch = search_cube_c(im1,info);           
            v_currpatch = currpatch(:);dist = 0;
            for s = 1:numel(v_currpatch)
                dist = dist + (v_currpatch(s)-v_refpatch(s))^2;
            end
            
%             dist = compute_norm_mp(v_refpatch,v_currpatch,ps1);
            
%             dist = norm(refpatch(:)-currpatch(:));

            count = count+1;
            distvals(count) = dist;
            similarity_indices(count,:) = [i1 j1 k1];
        end
    end
end


similarity_indices = similarity_indices(1:count,:);
distvals = distvals(1:count);



if count > maxK
    [~,sortedindices] = sort(distvals,'ascend');
    similarity_indices = similarity_indices(sortedindices(1:maxK),:);
    count = maxK;
end

end

