function [u, v, edgeMap] = DIcalcGVFfield(im, mu, iterations, curFigData, snake, varargin)
% 
% [u, v, edgeMap] = calcGVFfield(im, mu, iterations, curFigData, ...)
% 
% Computes a gradient vector flow (GVF) field as described
% in (Xu & Prince, 1998).
% 
% input:
%     im - the source image
%     mu - expected field smoothness--for gradient
%             vector diffusion (Xu & Prince 1998)
%     iterations - number of diffusion iterations
% 
% output:
%     u, v - matrices containing x and y components,
%               respectively, of the calculated field
% 
%     edgeMap - the edge map calculated from the image (not
%                          of much interest once the GVF field has been
%                          calculated, but available if desired)
% 
%     options can contain:
%             displayGraphics - if set to 1, show auxilary graphics
%             edgeSuppresion - is used to enable the user to select edge 
%                                            sensetivity level. The higher the values,
%                                            the lower the sensetivity  will be.
%              reEdgeMap - enabels the user to give a costom initial
%                                        edge map - needed for seccond
%                                        segmentation stage.
% 


if exist('varargin', 'var')
  assignVars(varargin); %parse optional variables
end


% set defaults
if ~exist('displayGraphics', 'var')
  displayGraphics = 0;
end

if ~exist('edgeSuppresion', 'var')
  edgeSuppresion = 0.02;
end


%% calculate edge map (Xu & Prince, 1998a)

% calculate edge map (squared magnitude of gradient) & scale to [0, 1]
if exist('DirectionalEdgeMap', 'var') &&  (DirectionalEdgeMap == true) % Directional edges case for 2nd iteration
    temp_mask = poly2mask(snake(:,1), snake(:,2), size(im,1), size(im,2));
    SDM = bwdist(temp_mask) - bwdist(~temp_mask);
    SDMx = dx5tap(SDM);
    SDMy = dy5tap(SDM);
    
    Ix = dx5tap(im);
    Iy = dy5tap(im);
    temp = SDMx.*Ix + SDMy.*Iy;
    unscaled = temp.*(temp>max(temp(:))/13);
else
    dIdx = dx5tap(im);
    dIdy = dy5tap(im);
    unscaled = dIdx.^2 + dIdy.^2;
end


if displayGraphics && isfield(curFigData.extra_data_axes, 'Unfiltered_Edge_map')
    set(0,'CurrentFigure',curFigData.figure_handle);
    set(curFigData.figure_handle,'CurrentAxes', curFigData.extra_data_axes.Unfiltered_Edge_map);
    cla; imshow(unscaled,[]); title('Unfiltered Edge map');
end

% clean up the edge map by establishing a minimum magnitude
minMag = edgeSuppresion * (mean2(unscaled) + 1 * std2(unscaled));
edgeMap = imadjust(unscaled, [minMag max(unscaled(:))], []);
fx = dx5tap(edgeMap);
fy = dy5tap(edgeMap);

% if desired, draw edge map & its gradient (initial state of GVF field)
if displayGraphics 
    if isfield(curFigData.extra_data_axes, 'Edge_map')
        set(0,'CurrentFigure',curFigData.figure_handle);
        set(curFigData.figure_handle,'CurrentAxes', curFigData.extra_data_axes.Edge_map);
        cla; imshow(edgeMap, []); title('Edge map');
    end
    
    eu = fx;
    ev = fy;
    edgeGradMag = sqrt((eu .^ 2) + (ev .^ 2));
    edgeGradMag = edgeGradMag + ...
        min(min(edgeGradMag(find(edgeGradMag > 0)))) + realmin;
    
    if isfield(curFigData.extra_data_axes, 'Non_normalized_Gradient_Gield')
        set(0,'CurrentFigure',curFigData.figure_handle);
        set(curFigData.figure_handle,'CurrentAxes', curFigData.extra_data_axes.Non_normalized_Gradient_Gield);
        cla;
        quiver(imresize(eu, 0.25, 'bicubic'), imresize(ev, 0.25, 'bicubic'));
        title('NOT norm edge map gradient (downsampled)');
        axis off;
        axis('ij');
    end
    
    neu = eu ./ edgeGradMag;
    nev = ev ./ edgeGradMag;
 
    if isfield(curFigData.extra_data_axes, 'Normalized_Gradient_Gield')
        set(0,'CurrentFigure',curFigData.figure_handle);
        set(curFigData.figure_handle,'CurrentAxes', curFigData.extra_data_axes.Normalized_Gradient_Gield);
        cla;
        quiver(imresize(neu, 0.15, 'bicubic'), imresize(nev, 0.15, 'bicubic'));
        title('normalized edge map gradient');
        axis off;
        axis('ij');

        drawnow;
    end
end


%% iterative solution of diffusion equations (Xu & Prince, 1998a)

% compute coefficients (Xu & Prince, 1998a)
b = (fx .^ 2) + (fy .^ 2);
c1 = b .* fx;
c2 = b .* fy;

% start the GVF field as the gradient of the edge map
u = fx;
v = fy;

% iterate for desired number of iterations, each time adding to
% the GVF field its partial temporal derivative calculated using
% equations 15a and 15b in (Xu & Prince, 1998a)
for m = 1:iterations
  u = u + (mu .* (dxx5tap(u) + dyy5tap(u))) - (b .* u) + c1;
  v = v + (mu .* (dxx5tap(v) + dyy5tap(v))) - (b .* v) + c2;
end

