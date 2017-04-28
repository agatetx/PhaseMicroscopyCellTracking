function performTrackingMaskExtraction(handles)
% 
% preformTestSegmentation(handles)
% 
% The function preforms segmentation on a sequence of frames,
% the user spasifies initial snake and edge (optional) and the function 
% use this snake for the next frames.
% (preforms two segmentation stages) 
%  saves a sequence of image masks and overlays
%
% Input: 
%     handles - standarts GUI handles array. 
%     
% Output:
%     The function does not return arguments.
%     


%% basic sequence settings initialization
frames =  handles.global.FrameList';
dilateFactor = str2num(get(handles.editDilateFactor,'String'));
edgeSuppresion = str2num(get(handles.editEdgeSuppresion,'String'));
cropFactor = str2num(get(handles.editCropFactor,'String'));
iterations = str2num(get(handles.editSegIter,'String'));
displayGraphics = get(handles.checkboxDisplayGraphics,'Value');


%% open the first image file
[Im orig_img_size MaxVal] = load_image(handles, frames(1));
[maxY, maxX] = size (Im);

%% get relevant intensity range fron user
curFigData = UpdateFigData(handles, [], true);
set(handles.figureMain,'CurrentAxes', handles.plotTracking);
set(curFigData.status_handle,'String', 'User input');

mkdir(sprintf('%s\\history',handles.global.folderName));
% UserIntensityRangeFile = sprintf('%shistory\\frame%dIntensityRange.mat', handles.global.folderName, frames(1));
% if exist(UserIntensityRangeFile, 'file')
%     load(UserIntensityRangeFile);
% else
%     [edgePoints, edgeScan] = getUserEdgeForGUI(Im);
%     % from edge get intensity range for isis
%     intensities = Im(edgeScan);
%     intensityRange = [min(intensities), max(intensities)];
%     save(UserIntensityRangeFile, 'intensityRange');
% end
% 
% if get(handles.checkboxUseSigmodial,'Value')
%     Im = isis(Im, intensityRange(1), intensityRange(2));
% end


%% get initial contour from user
UserSnakeFile = sprintf('%shistory\\frame%dSnake.mat', handles.global.folderName, frames(1));
if exist(UserSnakeFile, 'file')
    load( UserSnakeFile);
    snake(:, 1:2) = snake(:, 1:2) *(maxX/savedMaxX); % assume same resize factor for rows and columns
    cla;
    imshow(Im); axis auto; title('Last snake initilization');
    hold on;
    plot(snake(:,1), snake(:,2), '-+');
    choice = questdlg('Use current snake?', 'Snake initilization', 'yes', 'no',  'yes');
    
end
if (~exist(UserSnakeFile, 'file') | ~strcmp(choice, 'yes'))
    [snake, nextAvailTag] = getUserSnakeForGUI(Im);
    [savedMaxY savedMaxX] = size(Im);
    save(UserSnakeFile, 'snake','nextAvailTag', 'savedMaxX');
end
intensities = Im(MaskFromSnake(snake, maxY, maxX))*MaxVal;
intensityRange = [min(intensities), max(intensities)];
if get(handles.checkboxUseSigmodial,'Value')
    Im = isis(Im, intensityRange(1), intensityRange(2));
end
MaxVal = max(intensities);


outline = snake(:, 1:2)';  
numPoints = size(outline, 2);
outlineXY = [outline(1, :); maxY - outline(2, :); ones(1, numPoints)];

% the bandpass filter used for now
bandpassPT = zeros(size(Im));
bandpassPT(20:64, :) = 1;
bandpassF = ifftshift(iPolTransformFast(bandpassPT));

% figure out initial position
centroid = mean(outlineXY(1:2, :)')';
origCentroid = centroid;
prevCentroid = centroid;
accumDispXY = [0; 0];
prevAccumDispXY = accumDispXY;

% figure out initial orientation
displacement = -centroid;
translationMatrix = [1, 0, displacement(1); ...
                     0, 1, displacement(2); ...
                     0, 0, 1];
[majorAxis, minorAxis] = findPrincipleAxisFromPoints(outlineXY, translationMatrix);

%% we need to know whether the minorAxis is in the direction of orientation
%% or against it; for that we need an approximate orientation
UserOrientationFile = sprintf('%shistory\\frame%dapproximateOrientation.mat', handles.global.folderName, frames(1));
if exist(UserOrientationFile, 'file')
        load (UserOrientationFile);
        approximateOrientation = approximateOrientation * (maxX/savedMaxX); % assume same resize factor for rows and columns
        headPoint = headPoint * (maxX/savedMaxX);
else
    [approximateOrientation ,headPoint] = getUserOrientationForGUI(Im, outlineXY, centroid);
    [savedMaxY savedMaxX] = size(Im);
    save(UserOrientationFile, 'approximateOrientation','headPoint','savedMaxX');
end
RelativeAngle = (atan2(approximateOrientation(2),approximateOrientation(1))-pi/2);
tmp = max(max(snake(:,1)) - min(snake(:,1)), max(snake(:,2)) - min(snake(:,2)))*2;
SelfFrameImgSize = [ tmp tmp ];

if approximateOrientation' * minorAxis < 0
  minorAxis = -minorAxis;
end
% orientationAngle = atan2(minorAxis(2), minorAxis(1));
% origOrientationAngle = orientationAngle;
% prevOrientationAngle = orientationAngle;
% accumRotAngle = 0;



% perform initial segmentation 
set(handles.listboxFrameList, 'Value', 1);
set(handles.figureMain,'CurrentAxes', handles.plotSegmentationTest)
imshow(Im);
set(handles.textFrameID,'String', num2str(frames(1)));
% snake = contourc(maskForImageFromOutline(oldIm, snake(:,1:2)', 1), [0 0]);
curFigData = UpdateFigData(handles, curFigData, true);
[snake] = performSegmentation(Im, snake, nextAvailTag, handles, cropFactor, iterations, curFigData, edgeSuppresion);
centroidIJ = mean(snake(:,1:2))';
distIJfilt = headPoint-centroidIJ';
[headPoint] = findClosestPoint(snake,centroidIJ',distIJfilt);
% save a mask image file for the achived segmentation
[mask] = SaveMaskFromSnake(Im, snake, maxY, maxX, frames(1), handles,headPoint, orig_img_size, SelfFrameImgSize, RelativeAngle); 

% alright, let's go for the rest of the images in the sequence
oldframe = frames(1);
ind = 2;
for curframe = frames(2:end)
    if( oldframe+1 ~= curframe)
        warndlg(sprintf('Some frames are missing between frame %d and %d.\nTracking might fail due to large cell deformation between these frames.',oldframe, curframe), 'modal');
    end
    
    % prepare GUI for next frame processing
    curFigData = UpdateFigData(handles, curFigData);
    displayGraphics = get(handles.checkboxDisplayGraphics,'Value');
    set(handles.textFrameID,'String', num2str(curframe));
    set(curFigData.status_handle,'String', 'Tracking');
    drawnow;
    
    % load next frame and save the previous one for tracking purpuses
    oldIm = Im;
    Im = load_image(handles, curframe, MaxVal);
    if get(handles.checkboxUseSigmodial,'Value')
        Im = isis(Im, intensityRange(1), intensityRange(2));
    end
    
    set(handles.listboxFrameList, 'Value', ind);
    set(handles.figureMain,'CurrentAxes', handles.plotSegmentationTest)
    imshow(Im);


  %% Main tracking procedure
    % prepare data for tracking procedure:
    mask = maskForImageFromOutline(oldIm, snake(:,1:2)', 1);

     % calculate rotation and translation
     [rotAngle, dispIJ] = findRotationTranslationForGUI(oldIm, mask, Im, ...
        centroidIJ, bandpassF, intensityRange(1), intensityRange(2), curFigData,'displayGraphics', displayGraphics);

    RelativeAngle = RelativeAngle + rotAngle;
    
    ang = abs(acos(distIJfilt*dispIJ'/sqrt(sum(distIJfilt.^2))/sqrt(sum(dispIJ.^2))));
%          ang*180/pi
%          dispIJ
     if(ang < pi/3 ) %(max(abs(dispIJ)) < max(maxX, maxY)/5) % check if a microscope movement has occured
         alpha = 0.9;%1 - (ang/pi*3)^4;
        distIJfilt = alpha*distIJfilt*[cos(rotAngle), sin(rotAngle); -sin(rotAngle), cos(rotAngle)]' + (1-alpha)*dispIJ;
%            distIJfilt =  alpha*distIJfilt + (1-alpha)*dispIJ;
     end
     
    % prepare translation matrix
    snakeTranslationMatrix = [1, 0, -centroidIJ(1); 0, 1, -centroidIJ(2); 0, 0, 1];
    snakeRotationMatrix = [cos(rotAngle), sin(rotAngle), 0; -sin(rotAngle), cos(rotAngle), 0; 0, 0, 1];
    snakePositionMatrix = [1, 0, (centroidIJ(1)+dispIJ(1)); 0, 1, (centroidIJ(2)+dispIJ(2)); 0, 0, 1];
    snakeTransformationMatrix = snakePositionMatrix * snakeRotationMatrix * snakeTranslationMatrix;

    % apply detected translation to snake
    snake_tmp = [snake(:,1:2) ones(size(snake,1),1)];
    snake_tmp = snake_tmp*snakeTransformationMatrix';
    snake(:,1:2)  = snake_tmp(:,1:2);
    
    % dilate the mask before using it as initial snake for courrent image
    if(dilateFactor > 1)
        mask = MaskFromSnake(snake, maxY, maxX);
        dilatePixels = sqrt((max(snake(:,1))-min(snake(:,1)))*(max(snake(:,2))-min(snake(:,2))))*(dilateFactor-1)/2;
        mask = imdilate(logical(mask), strel('disk',round(dilatePixels)) ,'same');        
        mask([1 maxY],1:maxX) = 0; mask(1:maxY, [1 maxX]) = 0; % deal with dialation reaching image border
        snake = contourc(double(mask), [0 0]);
        snake = snake(:,2:end-1)';
        snake(:,3) =  1:length(snake);
        
    end
    
    if(max(snake(:,1)) > maxX || min(snake(:,1)) < 1 || max(snake(:,2)) > maxY || min(snake(:,2)) < 1)
        throw(MException('Error:Not Good', 'Initial snake out of bounds of the image'));
    end

    
    % perform extended GVF segmentation
    curFigData = UpdateFigData(handles, curFigData);
    
    global gTime_tot;
    global gNum;
    if isempty(gTime_tot)
        gTime_tot = 0;
        gNum = 0;
    end
    tic;
    [snake] = performSegmentation(Im, snake, nextAvailTag, handles, cropFactor, iterations, curFigData, edgeSuppresion);
    gTime_tot = gTime_tot + toc;
    gNum = gNum + 1;
    gTime_tot / gNum
    
    
    stats = regionprops(mask, 'Centroid');
    centroidIJ = stats.Centroid';
    
     % update head point 
%     headPoint_tmp = [headPoint 1]*snakeTransformationMatrix';
%     headPoint = headPoint_tmp(1:2);
    [headPoint] = findClosestPoint(snake, centroidIJ', distIJfilt);
    
     % save a mask image file for the achieved segmentation
     angle_rel = atan2(-distIJfilt(2), distIJfilt(1))-pi/2;
    [mask] = SaveMaskFromSnake(Im, snake, maxY, maxX, curframe, handles,headPoint, orig_img_size, SelfFrameImgSize, angle_rel);
    
    
    oldframe = curframe;
    ind = ind + 1;
end


set(curFigData.status_handle,'String', 'Idle');