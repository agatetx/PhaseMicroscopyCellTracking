function preformTestSegmentation(handles)
% 
% preformTestSegmentation(handles)
% 
% The function is called by a callback function of the test segmentation button.
% it preforms a single segmentation testing current parameters.
% 
% Input: 
%     handles - standarts GUI handles array. 
%     
% Output:
%     the function does not return arguments.
%     

%% basic segmentation settings initialization
list = get(handles.listboxFrameList, 'String');
frame = str2num(list(get(handles.listboxFrameList, 'Value'),:));
cropFactor = str2num(get(handles.editCropFactor,'String'));
iterations = str2num(get(handles.editSegIter,'String'));
edgeSuppresion = str2num(get(handles.editEdgeSuppresion,'String'));


%% load requested image
img = load_image(handles, frame);
[maxY, maxX] = size (img);



%% get relevant intensity range fron user
set(handles.figureMain,'CurrentAxes', handles.plotSegmentationTest);
mkdir(sprintf('%s\\history',handles.global.folderName));

% UserIntensityRangeFile = sprintf('%shistory\\frame%dIntensityRange.mat', handles.global.folderName, frame);
% if exist(UserIntensityRangeFile, 'file')
%     load(UserIntensityRangeFile);
% else
%     [edgePoints, edgeScan] = getUserEdgeForGUI(img);
%     % from edge get intensity range for isis
%     intensities = img(edgeScan);
%     intensityRange = [min(intensities), max(intensities)];
%     save(UserIntensityRangeFile, 'intensityRange');
% end

% if get(handles.checkboxUseSigmodial,'Value')
%     img = isis(img, intensityRange(1), intensityRange(2));
% end


%% get initial contour from user
UserSnakeFile = sprintf('%shistory\\frame%dSnake.mat', handles.global.folderName, frame);
if exist(UserSnakeFile, 'file')
    load( UserSnakeFile);
    snake(:, 1:2) = snake(:, 1:2) *(maxX/savedMaxX); % assume same resize factor for rows and columns
    imshow(img);
    hold on;
    plot(snake(:,1), snake(:,2), '-+');
    choice = questdlg('Use current snake?', 'Snake initilization', 'yes', 'no',  'yes');
    
end
if (~exist(UserSnakeFile, 'file') | ~strcmp(choice, 'yes'))
    [snake, nextAvailTag] = getUserSnakeForGUI(img);
    [savedMaxY savedMaxX] = size(img);
    save(UserSnakeFile, 'snake','nextAvailTag', 'savedMaxX');
end


%% perform extended GVF segmentation
curFigData = UpdateFigData(handles, [], false);
performSegmentation(img, snake, nextAvailTag, handles, cropFactor, iterations, curFigData,  edgeSuppresion);

set(curFigData.status_handle,'String', 'Idle');