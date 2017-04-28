function outline = DetectCell(img)

resFactor = 5
img_scaled = imresize(img, 1/resFactor);
% figure, imshow(img), title('original image');

[junk threshold] = edge(img_scaled, 'sobel');
fudgeFactor = .5;
BWs = edge(img_scaled,'sobel', threshold * fudgeFactor);


se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);


BWsdil = imdilate(BWs, [se90 se0]);

BWdfill = imfill(BWsdil, 'holes');


BWnobord = imclearborder(BWdfill, 4);
tmp = bwdist(~(BWnobord));
[junk1 ind] = max(tmp(:));
[c r] = ind2sub(size(BWnobord), ind);
bw = imresize(bwselect(BWnobord,r,c,8), resFactor);
BWfinal = imdilate(bw ,strel('disk',10));



% figure, imshow(BWfinal), title('segmented image');


outline = contourc(bw-0.5, [0 0])';
outline = outline(2:10:end, :);
% Segout = Capture1_000_0;
% Segout(BWoutline) = max(max(Capture1_000_0));
% figure, imshow(Segout), title('outlined original image');
