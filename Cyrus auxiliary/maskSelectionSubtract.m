function [foreground, fillcolor] = maskSelection(im, mask)

% [foreground, background] = maskSelection(im, mask)
%
% splits an image into foreground and background based on a mask
% the mask acts as an alpha channel for the image to generate the
% foreground (mixed with the background color which is the average
% intensity of the background in the original image) and (1 - mask)
% serves as the alpha channel for the background
%
%   im          the image to be split
%
%   mask        the foreground mask; it is the same size as im.
%               Pixels with values of 1 are foreground, 0 are
%               background, and values in between allow smooth
%               transitions between foreground and background
%
%   foreground  the foreground image (taken from areas that are 1
%               in the mask)
%
%   background  the background image (taken from areas that are 0
%               in the mask)
%
% Cyrus A Wilson  September 2004

bgmask = 1 - mask;
fillcolor = sum(sum(bgmask .* im)) / sum(sum(bgmask));
% fillcolor is the average intensity of the background region

% imSubtracted = im - fillcolor;
% foreground = (mask .* im) + (bgmask .* fillcolor);
foreground = mask .* (im - fillcolor);
% background = (bgmask .* im) + (mask .* fillcolor);

