function [Im im_size MaxVal] = load_image(handles, num, MaxVal)
% 
% res = check_user_abort(handles)
% 
% A GUI helper function to load image of index 'num'
% from the user selected sequence
% 
% input:
%     handles - standard GUI handles array
%     num - index of image to  be loaded
%     
% output:
%     Im - loaded image
%         
        

    fileName = sprintf(handles.global.fileName, num);
    folderName = handles.global.folderName;
    resize_factor = str2num(get(handles.editResizeFactor, 'String'));
    Im = double(imread([folderName 'phase\' fileName]));
    im_size = size(Im);
    Im = imresize(Im, resize_factor);
  
    if(nargin > 2)
        Im = Im/MaxVal;
        Im(Im > 1) = 1;
% %         Im = (Im - intensityRange(1))/(intensityRange(2) - intensityRange(1));
% %         Im(Im < 0) = 0; Im(Im > 1) = 1;
%         Im = Im/intensityRange(2);
%         Im(Im > 1) = 1;
    else
        MaxVal = max(Im(:));
        Im = double(Im)/MaxVal;
    end