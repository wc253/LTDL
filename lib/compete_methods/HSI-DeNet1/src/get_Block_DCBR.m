function [net, i] = get_Block_DCBR( net, i, f_in, f_out, p, s, relu_param)
%GET_BLOCK_CBR Summary of this function goes here
%   Detailed explanation goes here

conv_param = struct('f', [4 4 f_in f_out], 'pad',  p,'stride', s, 'bias', false); 
bn_param = struct('depth', f_out, 'epsilon', 1e-5);
 
i = i+1;  net  = get_DecConv_dag(net, i, sprintf('x%d',i-1), sprintf('x%d',i), conv_param);
i = i+1;  net.addLayer(sprintf('bn%d',i),   dagnn.BatchNorm('numChannels', bn_param.depth, 'epsilon', bn_param.epsilon), sprintf('x%d',i-1),  sprintf('x%d',i),{sprintf('g%d',i), sprintf('b%d',i), sprintf('m%d',i)});
i = i+1;  net = get_ReLU_dag(   net, i, sprintf('x%d',i-1), sprintf('x%d',i), relu_param);

end

