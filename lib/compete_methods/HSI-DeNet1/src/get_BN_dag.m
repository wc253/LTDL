function [ net ] = get_BN_dag(net, i, input, output, param)
%GET_CONV_DAG Summary of this function goes here
%   Detailed explanation goes here

net.addLayer(sprintf('bn%d',i),   dagnn.BatchNorm('numChannels', param.depth, 'epsilon', param.epsilon), input,  output,{sprintf('g%d',i), sprintf('b%d',i), sprintf('m%d',i)});

return;