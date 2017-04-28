function init_test_seg_frame(hObject, handles)
% 
% init_test_seg_frame(hObject, handles)
% 
% A GUI helper function to initilize  the Segmentation
% pannel to the user selected sequence
% 
% input:
%     hObject - handle to GUI object who's parent is the main figure
%     handles - standard GUI handles array
%     
% output:
%     the function does not return arguments
%         
        

folderName = handles.global.folderName;
% initialFrame = handles.global.initialFrame;
% finalFrame= handles.global.finalFrame;
frameList = handles.global.FrameList;
set(handles.listboxFrameList, 'String', frameList);
set(handles.listboxFrameList, 'Value',1);
set(handles.textTestStatus,'String', 'Idle');

% set current file name and create a new directory for the masks
list = get(handles.listboxFrameList, 'String');
frame = str2num(list(get(handles.listboxFrameList, 'Value'),:));

mkdir([folderName 'masks']);
img = load_image(handles, frame);
handles.global.seg_img = img;
guidata(hObject, handles);

set(handles.figureMain,'CurrentAxes', handles.plotSegmentationTest);
cla;
imshow(img);
axis image;
title(' ');