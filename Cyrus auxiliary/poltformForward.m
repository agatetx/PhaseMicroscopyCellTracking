function X = poltformForward(U, T)

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

u = U(:, 1) - (tdata.center(1) + 1); % is this right?
v = (tdata.center(2) + 1) - U(:, 2);

[theta, rho] = cart2pol(u, v);
negatives = theta < 0;
theta(negatives) = theta(negatives) + 2*pi;

x = (theta * ((tdata.numCols - 1) / (2*pi))) + 1;
y = (rho * ((tdata.numRows - 1) / tdata.maxRadius)) + 1;
X = [x, y];
