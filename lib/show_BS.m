function show_result = show_BS(D,B,F,enList,methodname)
sizD = size(D);
frames = 5;
n = length(enList);
n_frames = [10:10:50];
%I0 = zeros(sizD(1),frames*sizD(2));
BF = zeros(2*sizD(1),frames*sizD(2));
plot_m  = tight_subplot(n+1,1,[.01 .01],[.01 .01],[.01 .01]);
I_D = 1-zeros(2*sizD(1),frames*sizD(2));
for i = 1:frames
    I_D((1+sizD(1)):2*sizD(1),(i*sizD(2)-sizD(2)+1):(i*sizD(2)))        = D(:,:,n_frames(i));
end
axes(plot_m(1));
imshow(I_D);ylabel(['Original']);
for m = 1:length(enList)
    B1 = B{enList(m)};
    F1 = F{enList(m)};
    I_1 = BF;
%     m = 1;
    for i = 1:frames
        I_1(1:sizD(1),(i*sizD(2)-sizD(2)+1):(i*sizD(2)))           = B1(:,:,n_frames(i));
        I_1((1+sizD(1)):2*sizD(1),(i*sizD(2)-sizD(2)+1):(i*sizD(2))) = abs(double(F1(:,:,n_frames(i))));
    end
    axes(plot_m(m+1));
    imshow(I_1);ylabel(methodname{enList(m)});
end