function [ImCrop xmin ymin] = crop_cell(Im, snake, cropFactor)

% 
% [ImCrop xmin ymin] = crop_cell(Im, snake, cropFactor)
% 
% This function crops a box inside the original image containing the current 
% snake and some surrounding area according to the cropFactor parameter
% 
% input:
%       Im - full greyscale image
%       snake - a snake to be cropped around
%       cropFactor - a factor to indicate how much of the surrounding area 
%                                    we would like the cropped image to contain
%                                   - cropFactor=1 will crop only the box surrounding the snake
%                                   - cropFactor>1 will contain more sorrounding area than the 
%                                      box surrounding the snake
%     
% output:
%       ImCrop - the resulting cropped image
%       xmin, ymin - the upper left coordinates of the cropped image in 
%                                the frame of reference of the original image
%


    xmin = min(snake(:,1));
    width = max(snake(:,1)) - min(snake(:,1));
    ymin = min(snake(:,2));
    height = max(snake(:,2)) - min(snake(:,2));
    
    xmax = min(size(Im,2), xmin+width * cropFactor);
    xmin = max(0,xmin - width*(cropFactor-1)/2);    
    width = xmax-xmin;
    
    ymax = min(size(Im,1), ymin+height * cropFactor);
    ymin = max(1,ymin - height*(cropFactor-1)/2);
    height = ymax - ymin;

    ImCrop = imcrop(Im,[xmin ymin width height]);
   
end

