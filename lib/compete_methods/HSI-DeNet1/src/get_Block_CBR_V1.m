function [netG, i, next_input] = get_Block_CBR_V1( netG, i,  f_in, f_out, f, s, sigma, epsilon, next_input)

    filters = sigma * randn(f, f, f_in, f_out, 'single');
    biases  = zeros(f_out, 1, 'single');
    
    % conv
    inputs  = { next_input };
    outputs = { sprintf('conv%d', i) };
    params  = { sprintf('conv%d_f', i), ...
        sprintf('conv%d_b', i)};
    
    netG.addLayer(outputs{1}, ...
        dagnn.Conv('size', size(filters), ...
        'pad', 1, ...
        'stride', s), ...
        inputs, outputs, params);
    
    idx = netG.getParamIndex(params{1});
    netG.params(idx).value         = filters;
    netG.params(idx).learningRate  = 1;
    netG.params(idx).weightDecay   = 1;
    
    idx = netG.getParamIndex(params{2});
    netG.params(idx).value         = biases;
%     netG.params(idx).learningRate  = 0.1;
    netG.params(idx).learningRate  = 0;
    netG.params(idx).weightDecay   = 0;
  
 % BN
    inputs  = { sprintf('conv%d', i) };
    outputs = { sprintf('BN%d', i) };
    params  = { sprintf('g%d',i), sprintf('b%d',i), sprintf('m%d',i)};
    
    netG.addLayer(outputs{1}, ...
      dagnn.BatchNorm('numChannels', f_out, ...
      'epsilon', epsilon),...
      inputs,  outputs,   params);

    idx = netG.getParamIndex(params{1});
%     netG.params(idx).value         = ones(n,1,'single') ;
    netG.params(idx).value         = sigma * randn( f_out, 1, 'single');    
    netG.params(idx).learningRate  = 1;
%     netG.params(idx).weightDecay   = 1;    
    netG.params(idx).weightDecay   = 0;    
    
    idx = netG.getParamIndex(params{2});
    netG.params(idx).value         = zeros(f_out,1,'single') ;
    netG.params(idx).learningRate  = 1;
%     netG.params(idx).weightDecay   = 1;     
    netG.params(idx).weightDecay   = 0;    
 
    meanvar  =  [zeros(f_out,1,'single'), 0.01*ones(f_out,1,'single')];    
    idx = netG.getParamIndex(params{3});
%     netG.params(idx).value         = zeros(n,2,'single') ;
    netG.params(idx).value         = meanvar;
%     netG.params(idx).learningRate  = 0.1;
    netG.params(idx).learningRate  = 1;
%     netG.params(idx).weightDecay   = 1;
    netG.params(idx).weightDecay   = 0;     
    
    % ReLU
    inputs  = { sprintf('BN%d', i) };
    outputs = { sprintf('relu%d', i) };
    
    netG.addLayer(outputs{1}, ...
        dagnn.ReLU('leak', 0.0), ...
        inputs, outputs);
    
    next_input = outputs{1};
    i = i+1;
end    