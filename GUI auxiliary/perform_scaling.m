function res = perform_scaling(im,mask)

[m, n] = size(im);
if nargin > 1
    bgmask = 1 - mask;
    fillcolor = sum(sum(bgmask .* im)) / sum(sum(bgmask));
else
    fillcolor = 0;
end
if( m > n )
    scale = 512 / m;
    shift = round ((m-n)*scale/2);
    shrinkedIm=imresize (im, scale,'bilinear');
    res = ones(512)*fillcolor;
    res(:,shift:(shift+size(shrinkedIm,2)-1))=shrinkedIm;
else 
    scale = 512 / n;
    shift = round ((n-m)*scale/2);
    shrinkedIm=imresize (im, scale,'bilinear');
    res = ones(512)*fillcolor;
    res(shift:(shift+size(shrinkedIm,1)-1),:)=shrinkedIm;     
end