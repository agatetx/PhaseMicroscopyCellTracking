function U = poltformInverse(X, T)

tdata = T.tdata;

% % for now we'll assume for speed that all this was provided in tdata:
% if ~isfield(tdata, 'center')
%   halfHeight = 0.5 * tdata.numRows;
%   halfWidth = 0.5 * tdata.numCols;
%   tdata.center = [halfWidth - 0.5, halfHeight - 0.5]; %we might want to change this
% end
% 
% if ~isfield(tdata, 'maxRadius')
%   halfHeight = 0.5 * tdata.numRows;
%   halfWidth = 0.5 * tdata.numCols;
%   tdata.maxRadius = min([halfHeight, halfWidth]) - 0.5;
% end
% 

x = X(:, 1);
y = X(:, 2);

theta = (x - 1) * ((2*pi) / (tdata.numCols - 1));
rho = (y - 1) * (tdata.maxRadius / (tdata.numRows - 1));

[u, v] = pol2cart(theta, rho);
U = [u + tdata.center(1) + 1, -v + tdata.center(2) + 1];
