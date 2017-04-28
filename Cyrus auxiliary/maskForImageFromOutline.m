function mask = maskForImageFromOutline(im, outline, supersampling)

% mask = maskForImageOutline(im, outline, supersampling)
%
% given image im and outline of region of interest, generates a
% mask slightly larger than the region and gaussian blurred
%
%   im              image the mask will be applied to (the mask
%                   image returned will be the same size as im)
%
%   outline         the vertices of the outline: a 2 by N matrix
%                   where N is the number of vertices; the first
%                   row contains the X coordinates and the second,
%                   the Ys. The outline need not be closed.
%
%   supersampling   supersampling factor; default is 4 (e.g. for a
%                   512 x 512 image, the binary mask will be
%                   rendered at 2048 x 2048 and then downsampled)
%                   This antialiasing is to alleviate artifacts in
%                   the frequency domain.
%
% Cyrus A Wilson    September 2004

if ~exist('supersampling', 'var')
  supersampling = 4;
end

% rasterize mask at higher resolution

superim = zeros(supersampling * size(im));

mask1 = roipoly(superim, supersampling * outline(1, :), ...
                         supersampling * outline(2, :));

% dilate the mask
% (currently the mask is enlarged relative to the original outline
%  by dilation; but another approach would be to enlarge the outline
%  itself)

mask2 = imdilate(mask1, strel('disk', supersampling * 40));

% now downsample to 1x resolution

if (supersampling == 1)
  mask3 = double(mask2);
else
  mask3 = imresize(double(mask2), size(im), 'bicubic');
end

% convolve with Gaussian

sigma = 15;
h = fspecial('gaussian', (4 * sigma) + 1, sigma);
% mask = imfilter(double(mask3), h, 'symmetric', 'same');
mask = imfilter(double(mask3), h, 0, 'same');

