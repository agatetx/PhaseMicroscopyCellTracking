function im = isis(im, imin, imax)

% Intelligent Sigmoidal Intensity Scaling
%
% function description coming soon
%
% Cyrus A Wilson    June 2003

center = 0.5 * (imax + imin);
width = 0.25 * (imax - imin);

im = sis(im, center, width, imax - imin, imin);