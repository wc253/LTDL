A = rand(4,4,4);
tic
A_d = ffd(A);
toc

tic
A_f = fft(A);
toc

