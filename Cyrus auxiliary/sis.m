function scaledIm = sis(im, center, width, amplitude, baseline)

% Sigmoidal Intensity Scaling
%
% function description coming soon
%
% Cyrus A Wilson    April 2003

steepness = 1 / width;
% scaledIm = baseline + amplitude ./ (1 + exp((-im .* steepness) + center));
scaledIm = baseline + amplitude ./ (1 + exp((center - im) .* steepness));

% % show response:
% 
% x = min(min(im)):max(max(im));
% figure(100);
% % plot(x, baseline + amplitude ./ (1 + exp((-x .* steepness) + center)));
% plot(x, baseline + amplitude ./ (1 + exp((center - x) .* steepness)));
