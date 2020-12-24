function [ net ]  = get_Sigmoid_dag(net, i, input, output)
%GET_RELU Summary of this function goes here
%   Detailed explanation goes here
net.addLayer(sprintf('Sigmoid%d',i), dagnn.Sigmoid, input, output);
 
end