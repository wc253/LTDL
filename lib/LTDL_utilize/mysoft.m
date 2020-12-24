function [X] = mysoft(B,lamda,p)
B = double(B);
X = sign(B).*max(abs(B)-lamda*abs(B).^(p-1),0); 
%X = tensor(X,dims);
end  
