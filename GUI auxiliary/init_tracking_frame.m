function init_tracking_frame(hObject, handles)
% 
% init_tracking_frame(hObject, handles)
% 
% A GUI helper function to initilize  the Tracking
% pannel to the user selected sequence
% 
% input:
%     hObject - handle to GUI object who's parent is the main figure
%     handles - standard GUI handles array
%     
% output:
%     the function does not return arguments
%   

frames = handles.global.FrameList;
initialFrame = frames(1);

set(handles.textTrackingStatus,'String', 'Idle');
set(handles.textFrameID,'String', num2str(initialFrame));
img = load_image(handles, initialFrame);
set(handles.figureMain,'CurrentAxes', handles.plotTracking)
cla;
imshow(img);
axis image;
title(' ');