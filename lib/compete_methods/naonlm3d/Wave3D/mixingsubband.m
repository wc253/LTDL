function [fima]=mixingsubband(fimau,fimao)
% Pierrick Coupe - pierrick.coupe@gmail.com                                  
% Jose V. Manjon - jmanjon@fis.upv.es                                        
% Brain Imaging Center, Montreal Neurological Institute.                     
% Mc Gill University                                                         
%                                                                            
% Copyright (C) 2010 Pierrick Coupe and Jose V. Manjon                       

s = size(fimau);

p(1) = 2^(ceil(log2(s(1))));
p(2) = 2^(ceil(log2(s(2))));
p(3) = 2^(ceil(log2(s(3))));

pad1 = zeros(p(1),p(2),p(3));
pad2 = pad1;
pad1(1:s(1),1:s(2),1:s(3)) = fimau(:,:,:);
pad2(1:s(1),1:s(2),1:s(3)) = fimao(:,:,:); 

[af, sf] = farras;
w1 = dwt3D(pad1,1,af);
w2 = dwt3D(pad2,1,af);
  
w1{1}{3} = w2{1}{3};
w1{1}{5} = w2{1}{5};
w1{1}{6} = w2{1}{6};
w1{1}{7} = w2{1}{7};

fima = idwt3D(w1,1,sf);
fima = fima(1:s(1),1:s(2),1:s(3));

% NAN checking
ind=find(isnan(fima(:)));
fima(ind)=fimau(ind);

% negative checking (only for rician noise mixing)
ind=find(fima<0);
fima(ind)=0;


% s = size(fimau);
% 
% p(1) = 2^(ceil(log2(s(1))));
% p(2) = 2^(ceil(log2(s(2))));
% p(3) = 2^(ceil(log2(s(3))));
% 
% pad1 = zeros(p(1),p(2),p(3));
% pad2=pad1;
% pad1(1:s(1),1:s(2),1:s(3)) = fimau(:,:,:);
% pad2(1:s(1),1:s(2),1:s(3)) = fimao(:,:,:); 
% 
% [af, sf] = farras;
% w1 = dwt3D(pad1,1,af);
% w2 = dwt3D(pad2,1,af);
% 
%   w1{1}{1} = (w1{1}{1} + w2{1}{1})/2;
%   w1{1}{2} = (w1{1}{2} + w2{1}{2})/2;
%   w1{1}{3} = w2{1}{3};
%   w1{1}{4} = (w1{1}{4} + w2{1}{4})/2;
%   w1{1}{5} = w2{1}{5};
%   w1{1}{6} = w2{1}{6};
%   w1{1}{7} = w2{1}{7};
% 
% fima = idwt3D(w1,1,sf);
% fima = fima(1:s(1),1:s(2),1:s(3));
