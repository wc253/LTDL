
function J = image_adjust(I, Imatch)

R=I(:,:,1);%获取原图像R通道  
G=I(:,:,2);%获取原图像G通道  
B=I(:,:,3);%获取原图像B通道  
Rmatch=Imatch(:,:,1);%获取匹配图像R通道  
Gmatch=Imatch(:,:,2);%获取匹配图像G通道  
Bmatch=Imatch(:,:,3);%获取匹配图像B通道  
Rmatch_hist=imhist(Rmatch);%获取匹配图像R通道直方图  
Gmatch_hist=imhist(Gmatch);%获取匹配图像G通道直方图  
Bmatch_hist=imhist(Bmatch);%获取匹配图像B通道直方图  
Rout=histeq(R,Rmatch_hist);%R通道直方图匹配  
Gout=histeq(G,Gmatch_hist);%G通道直方图匹配  
Bout=histeq(B,Bmatch_hist);%B通道直方图匹配  
J(:,:,1)=Rout;  
J(:,:,2)=Gout;  
J(:,:,3)=Bout;  