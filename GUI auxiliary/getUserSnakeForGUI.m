function [snake, nextAvailTag] = getUserSnakeForGUI(im)
% 
% [snake, nextAvailTag] = getUserSnake(im)
% 
% Adjusted from Cyrus's code to interact with GUI.
% Presents the user with an image, and has them create an initial
% snake for that image by adding vertices with the mouse (left
% clicks add new vertices, each connected to the previous one; other
% clicks or key presses end the process; the last added vertex is
% connected to the first added vertex)
% 
% input:
%     im - image to present user
%     
% output:    
%     snake - snake created by user
%     nextAvailTag - next available unique vertex tag
% 


scim = imadjust(im, stretchlim(im, 0));

CLim = stretchlim(scim, [0 0.98])';

% h = imshow(im, []); title('Specify initial snake');
imshow(im, []); title('Automatic recognition results');
userSnake = DetectCell(im);
imshow(im, []);
hold on;
plot(userSnake(:,1), userSnake(:,2), '-+');

choice = questdlg('Keep automatic initilization or specify user defined snake?', 'Automatic initilization', ...
    'Keep current', 'User initilization',  'Keep current');
if(strcmp(choice, 'User initilization'))
    h = imshow(im, []); title('Specify initial snake');
    [x,y] = getline('closed');
    ppoints = [x, y];
    userSnake = ppoints(1:(end),:);
    hold on;
    plot(userSnake(:,1), userSnake(:,2), '-+');
    hold off; drawnow;
end

CLim = get(gca, 'CLim');

numPoints = size(userSnake, 1);
tags = [1:numPoints];
nextAvailTag = numPoints + 1;
snake = [userSnake tags'];
