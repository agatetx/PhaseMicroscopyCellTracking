function [mask,mov] = SaveMaskFromSnake( im, snake, m, n, frame, handles,headPoint, orig_img_size, SelfFrameImgSize, RelativeAngle)
%
% [mask,mov] = SaveMaskFromSnake( im, snake, m, n, frame, handles,mov)
% 
% the function updates the GUI with the current axes.
% 
% input: 
%     im - The current frame the snake referred to.    
%     snake - contain information regardig plot demanded by GUI.
%     m, n - size of desired mask. 
%     frame - The number of the current frame.
%     handles - standarts GUI handles array. 
%     headPoint - A coordinate of a point on the snake or very close to it,
%                 in the cell front.
% output:
%     mask - the mask created from the snake.
%


[mask] = MaskFromSnake(snake, m, n);
overlay = zeros([m n 3]);

overlay(:, :, 1) = im;
overlay(:, :, 2) = im.*(~mask) + 0.7*mask;
overlay(:, :, 3) = im;

fileName = sprintf(get(handles.editFileName, 'String'), frame);
folderName = get(handles.editFolderName, 'String');
MasksFullName = sprintf('%s\\%s', [folderName 'masks'], fileName);
headPointullName = sprintf('%s\\%s', [folderName 'headPointMask'], fileName);
OverlaysFullName = sprintf('%s\\%s', [folderName 'overlays'], fileName);
SelfFrameFullName = sprintf('%s\\%s', [folderName 'SelfFrameRef'], fileName);

if (exist([folderName 'masks'], 'file') ~= 7)
        mkdir([folderName 'masks']);
end
if (exist([folderName 'overlays'], 'file') ~= 7)
        mkdir([folderName 'overlays']);
end
if (exist([folderName 'headPointMask'], 'file') ~= 7)
        mkdir([folderName 'headPointMask']);
end
if (exist([folderName 'SelfFrameRef'], 'file') ~= 7)
        mkdir([folderName 'SelfFrameRef']);
end

%save heading points 
headPointMask = zeros(size(mask));
headPointMask(round(headPoint(2)),round(headPoint(1))) = 1;
se = strel('disk',10);
headPointMask = imdilate(headPointMask,se);
headPointMask = boolean(headPointMask);
overlay(repmat(headPointMask, [1 1 3])) = 1;
headPointMask = double(headPointMask);
headPointMask(~headPointMask) = im(~headPointMask);


imwrite( imresize(mask, orig_img_size), MasksFullName, 'tif','compression', 'none');
imwrite( imresize(headPointMask, orig_img_size), headPointullName, 'tif','compression', 'none');
imwrite( imresize(overlay, orig_img_size), OverlaysFullName, 'tif','compression', 'none');


%% Save Self Frame Of Reference Image
% RelativeAngle = 0.35;
stats = regionprops(mask, 'Centroid');
Centroid = stats.Centroid;
% figure; imshow(mask); hold on; plot(Centroid(1), Centroid(2));
% SelfFrameImgSize = [256 256];
Xvec = 1:SelfFrameImgSize(2);
Yvec = 1:SelfFrameImgSize(1);
[MeshX MeshY] = meshgrid(Xvec-max(Xvec)/2, Yvec-max(Yvec)/2);

RotMeshX = cos(RelativeAngle)*MeshX + sin(RelativeAngle)*MeshY + Centroid(1);
RotMeshY = -sin(RelativeAngle)*MeshX + cos(RelativeAngle)*MeshY + Centroid(2);


% figure; imshow(im); hold on; plot(RotMeshX(:), RotMeshY(:), '+'); pause;
SelfFrameImg = interp2(im, RotMeshX, RotMeshY);
% figure; imshow(SelfFrameImg);
imwrite( SelfFrameImg, SelfFrameFullName, 'tif','compression', 'none');


% if (get(handles.checkboxSaveImages, 'Value') == 1)
%       
%     [s,m,mid] = mkdir([folderName 'contoured cells']);
%     
%     
%     f=figure('visible','off');
%     imshow(imresize(im,1/3), []);
%     title(sprintf('%s%d', 'frame:',frame));
%     
%     hold on; plot(snake(:, 1)/3, snake(:, 2)/3); hold off;
%     
%     set(f, 'Units', 'pixels', 'Position', [0, 0, 500, 476]);
%     set(f, 'paperunits', 'centimeters', 'paperposition', [0 0 10 10]);
%     
%     print(f,'-dtiff','-r254',sprintf('%s%d%s', [folderName '\contoured cells\contouredCells'],frame ,'.tif'));
%     
% end


