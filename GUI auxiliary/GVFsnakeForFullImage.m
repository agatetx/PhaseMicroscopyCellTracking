function [snake, nextAvailTag] = GVFsnakeForFullImage(im, snake, nextAvailTag, handles, curFigData,  varargin)
% 
% [snake, nextAvailTag] = GVFsnakeForFullImage(im, snake, nextAvailTag, handles,curFigData,  varargin)
% 
% This function implements the GVF snakes segmentation method.
% 
% input:
%     im - the image to preform segmentation on
%     snake - initial snake
%     nextAvailTag - index to next available index in snake
%     handles - standard GUI handles array
%     curFigData - contains information regarding plots demanded by GUI
%      options can contain:
%             fiterations - number of iterations snake segmentation
%             iterations - number of iterations for GVF field calculation 
%             extWeight, gammaV, alphaV, betaV, mu - internal algorithm (Xu & Prince, 1998) 
%                                                                      parameters - currently used default values
%             minSpacing, maxSpacing - snake maintainance parameters - currently used defaults values
% 
% output:
%     snake - final snake after segmentation
%     nextAvailTag - index to next available index in snake
% 
  

if exist('varargin', 'var')
  assignVars(varargin); %parse optional variables
end

% set defaults
if ~exist('bpKernel', 'var')
    filterScale = sqrt((max(snake(:,1))-min(snake(:,1)))*(max(snake(:,2))-min(snake(:,2))))/470;
	sigmaH = 4*filterScale; sigmaLP = 10*filterScale;
  bpKernel = fspecial('gaussian', 2 * ceil(3 * sigmaLP), sigmaH) - ...
             0.8 * fspecial('gaussian', 2 * ceil(3 * sigmaLP), sigmaLP);
end

if ~exist('mu', 'var')
  mu = 0.2;       %from (Xu & Prince, 1998)
end
if ~exist('iterations', 'var')
  iterations = 10;
end
if ~exist('extWeight', 'var')
  extWeight = 1;  %from (Xu & Prince, 1998)
end
if ~exist('gammaV', 'var')
  gammaV = 1;     %from (Xu & Prince, 1998)
end
if ~exist('alphaV', 'var')
  alphaV = 0.6;   %from (Xu & Prince, 1998)
end
if ~exist('betaV', 'var')
  betaV = 0.1;
end
if ~exist('minSpacing', 'var')
  minSpacing = 1;
end
if ~exist('maxSpacing', 'var')
  maxSpacing = 5;
end
if ~exist('fiterations', 'var')
  fiterations = 20;
end


curFigData = UpdateFigData(handles, curFigData);
displayGraphics = get(handles.checkboxDisplayGraphics,'Value');
varagin.displayGraphics = displayGraphics;

% initial filtering of intensity-scaled image
workIm = imfilter(im, bpKernel, 'symmetric', 'same', 'conv');

% calculate GVF field
[u, v, edgeMap] = DIcalcGVFfield(workIm, mu, iterations, curFigData, snake, varargin{:});

% normalize GVF
GVFfieldMag = sqrt((u .^ 2) + (v .^ 2));
GVFfieldMag = GVFfieldMag + ...
              min(min(GVFfieldMag(find(GVFfieldMag > 0)))) + realmin;
nu = u ./ GVFfieldMag;
nv = v ./ GVFfieldMag;

if displayGraphics && isfield(curFigData.extra_data_axes, 'GVF_field')
  set(0,'CurrentFigure',curFigData.figure_handle);
  set(curFigData.figure_handle,'CurrentAxes', curFigData.extra_data_axes.GVF_field);
  cla; quiver(imresize(nu, 0.1, 'bicubic'), imresize(nv, 0.1, 'bicubic'));
  title('normalized GVF field (downsampled)');

  axis off;
  axis('ij');
  drawnow;
end

% fit snake
[snake, nextAvailTag] = fitSnakeForGUI(snake, alphaV, betaV, gammaV, ...
                                 minSpacing, maxSpacing, ...
                                 extWeight, nu, nv, ...
                                 fiterations, nextAvailTag, im, handles, curFigData, ...
                                 varargin{:});



  