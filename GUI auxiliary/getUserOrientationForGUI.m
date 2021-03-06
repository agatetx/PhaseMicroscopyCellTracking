function [approximateOrientation , headPointXY] = getUserOrientationForGUI(im, outline, position)

% [approximateOrientation ,headPoint] = getUserOrientation(im, outline, position)
%
% function description coming soon
%
% Cyrus A Wilson    March 2005

imshow(flipud(im), []); axis xy;
hold on; plot(position(1), position(2), 'go');
plot(outline(1, :), outline(2, :));
hold off;

title('click near front center of cell'); drawnow;

[x, y] = ginput(1);
headPointXY = [x size(im,1)-y];
hold on; plot(x, y, 'ro');
plot([position(1) x], [position(2) y]);
hold off; drawnow;

approximateOrientation = [x; y] - position;
