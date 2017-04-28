function [majorAxis, minorAxis] = findPrincipleAxisFromPoints(snakePoints, translationMatrix, varargin)

% function description coming soon
%
% Cyrus A Wilson    December 2003   updated March 2005

if exist('varargin', 'var')
  assignVars(varargin); %parse optional variables
end

% set defaults
if ~exist('displayGraphics', 'var')
  displayGraphics = 0;
end


registered = translationMatrix * snakePoints;

if displayGraphics
	figure(11); plot(registered(1, :), registered(2, :), '*');
	rf = 256;
	axis([-rf rf -rf rf]); axis square; drawnow;
end

W = registered(1:2, :);

[O1, S, O2T] = svd(W);
O2 = O2T';

% rank-1 approximation:

O1prime = O1(:, 1);
majorAxis = O1prime;
minorAxis = O1(:, 2);

if displayGraphics
	Sprime = S(1, 1);
	O2prime = O2(1, :);
	
	reconstructedW = O1prime * Sprime * O2prime;
	
	% figure(12); plot(reconstructedW(1, :), reconstructedW(2, :), '*');
	O1points = rf * [[0 0]', O1prime];
	hold on; plot(O1points(1, :), O1points(2, :), 'g'); hold off;
	axis([-rf rf -rf rf]); axis square; drawnow;

  minorPoints = rf * [[0 0]', minorAxis];
	hold on; plot(minorPoints(1, :), minorPoints(2, :), 'r'); hold off;
	drawnow;
end
