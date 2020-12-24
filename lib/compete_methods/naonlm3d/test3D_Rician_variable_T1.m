% Jose V. Manjon - jmanjon@fis.upv.es
% Universidad Politecnica de Valencia
%
% Pierrick Coupe - pierrick.coupe@gmail.com                                  
% Brain Imaging Center, Montreal Neurological Institute.                     
% Mc Gill University                                                         
%                                                                            
% Copyright (C) 2010 Jose V. Manjon and Pierrick Coupe      

%**************************************************************************
%                                                                         *
%              Adaptive Non-Local Means Denoising of MR Images            *             
%              With Spatially Varying Noise Levels                        *
%                                                                         * 
%              Jose V. Manjon, Pierrick Coupe, Luis Marti-Bonmati,        *
%              D. Louis Collins and Montserrat Robles                     *
%                                                                         *
%**************************************************************************

%                          Details on BONLM3D filter                          
%***************************************************************************
%  The BONLM3D filter is described in:                                    *
%                                                                         *
%  P. Coupe, P. Yger, S. Prima, P. Hellier, C. Kervrann, C. Barillot.     *
%  An Optimized Blockwise Non Local Means Denoising Filter for 3D Magnetic*
%  Resonance Images. IEEE Transactions on Medical Imaging, 27(4):425-441, * 
%  Avril 2008                                                             *
% *************************************************************************
% 

%                       Details on Wavelet mixing Filter
%**************************************************************************
%  The hard wavelet subbands mixing is described in:                      *
%                                                                         *
%  P. Coupe, S. Prima, P. Hellier, C. Kervrann, C. Barillot.              *
%  3D Wavelet Sub-Bands Mixing for Image Denoising                        *
%  International Journal of Biomedical Imaging, 2008                      * 
% *************************************************************************

warning off;
addpath .\Wave3D

clc;
clear;

% read data
name ='t1_icbm_normal_1mm_pn0_rf0.rawb';
fid = fopen(name,'r');    
s=[181,217,181];
ima=zeros(s(1:3));
for z=1:s(3),    
  ima(:,:,z) = fread(fid,s(1:2),'uchar');
end;
fclose(fid);

% small volume
%ima=ima(101:150,101:150,81:90);

% min and max level of noise
minl = 1;
maxl = 15;
s=size(ima);

% noise modulation field
B=ones(3,3,3);
B(2,2,2)=3;
[x1,y1,z1] = meshgrid(1:3,1:3,1:3);
[x2,y2,z2] = meshgrid(1:2/(s(2)-1):3,1:2/(s(1)-1):3,1:2/(s(3)-1):3);
B = interp3(x1,y1,z1,B,x2,y2,z2,'cubic'); 
clear x2;clear y2;clear z2;

ind=find(ima>10);
range=255;

% for 1 to 15% of noise
for i=minl:2:maxl

%create noisy data (spatially variable rician noise)
level=i*max(ima(:))/100
rima=sqrt((ima+level*randn(s).*B).^2 + (level*randn(s).*B).^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wavelet Mixing Filter (Coupe 2008)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
h=level; % noise std .dev.
v=3;     % radius of search area
f1=1;    % radius of similarity patch (small)
f2=2;    % radius of similarity patch (big)
r=1;     % Rician tag: Rician(1), Gaussian(0)
fimau=MBONLM3D(rima,v,f1,h,r);
fimao=MBONLM3D(rima,v,f2,h,r);
%Mixing of the coefficient LLL of fimau and the high subbands of fimao
fima1=mixingsubband(fimau,fimao);
tmp1=toc
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% proposed filter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
tic;
fimau=MABONLM3D(rima,v,f1,r);
fimao=MABONLM3D(rima,v,f2,r);
%Mixing of the coefficient LLL of fimau and the high subbands of fimao
fima2=mixingsubband(fimau,fimao);
tmp2=toc
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%%% results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
error1(i)=sqrt(mean((fima1(ind)-ima(ind)).^2)) 
error2(i)=sqrt(mean((fima2(ind)-ima(ind)).^2))
psnr1(i)=20*log10(range/error1(i))
psnr2(i)=20*log10(range/error2(i))

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
clf
plot(minl:2:maxl,psnr1(minl:2:maxl),'bs-')
hold on
plot(minl:2:maxl,psnr2(minl:2:maxl),'g^:')
xlabel('Noise Standard Deviation(%)');
ylabel('PSNR')
title('T1')
legend('Wavelet mixing (Rician)','Proposed (Rician)');

mean(psnr1)
mean(psnr2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
