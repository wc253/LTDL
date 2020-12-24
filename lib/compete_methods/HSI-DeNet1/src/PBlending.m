function Y = PBlending(source, target, mask)

for i=1:size(mask,3)
    tmask = mask(:,:,i);
    mask(:,:,i) = bwmorph(tmask,'thin');
end

[Lh, Lv] = imgrad(target);
[Gh, Gv] = imgrad(source);

X = target;

Fh = Lh;
Fv = Lv;

for i=1:size(mask,1)
    for j=1:size(mask,2)
        if(mask(i,j,1)==1)
            X(i,j,:) = source(i,j,:);
            Fh(i,j,:) = Gh(i,j,:);
            Fv(i,j,:) = Gv(i,j,:);
        end
    end
end

Y = PoissonJacobi(X, Fh, Fv, mask);