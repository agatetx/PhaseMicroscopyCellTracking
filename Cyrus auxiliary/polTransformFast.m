function transformedIm = polTransformFast(im, XData, YData)

% Cyrus A Wilson    April 2005


[tdata.numRows, tdata.numCols] = size(im);
halfHeight = 0.5 * size(im, 1);
halfWidth = 0.5 * size(im, 2);

if ~exist('XData', 'var')
  XData = [1 tdata.numCols];
end

if ~exist('YData', 'var')
  YData = [1 tdata.numRows];
end

% currently I use as the maximum radius the radius of the largest
% circle which can fit inside im (as opposed to that of the smallest
% circle im can fit inside); this imposes a circular window on the
% data, but in my applications I cannot make use of the data outside
% that circle anyway

% tdata.maxRadius = sqrt(halfHeight^2 + halfWidth^2);
tdata.maxRadius = min([halfHeight, halfWidth]) - 0.5;

% tdata.center = [halfWidth - 0.5, halfHeight - 0.5];
% tdata.center = [halfWidth + 1, halfHeight + 1];
tdata.center = [halfWidth, halfHeight];

tform = maketform('custom', 2, 2, ...
                  @poltformForward, @poltformInverse, tdata);
transformedIm = imtransform(im, tform, 'bicubic', ...
                            'XData', XData, ...
                            'YData', YData);
% transformedIm = imtransform(im, tform, 'bicubic');
