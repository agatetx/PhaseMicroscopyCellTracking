function [snake] = performSegmentation(Im, snake, nextAvailTag, handles, cropFactor, iterations, curFigData, edgeSuppresion)
%     
% [snake] = performSegmentation(Im, snake, nextAvailTag, handles, cropFactor,...
%                     iterations, curFigData, displayGraphics, edgeSuppresion)
% 
% This function crops the image acording to the given snake and calls GVFsnakeForFullImage,
% which preform th segmentation,the segmentation is preform in two stages acording to 
% the user request.
% 
% Input:
%     Im - the current frame the snake referres to. 
%     snake - initial snake
%     nextAvailTag -  index to next available index in snake
%     handles - standarts GUI handles array.  
%     cropFactor - the ratio between snake bounding box and croping box.
%                                 should be > 1.
%     iterations - the number of iteration for the sementation. 
%     curFigData - contains information regardig plot demanded by GUI.
%     edgeSuppresion - a variable defining the amount of suppresion on the
%                                           detected edges in the image - good for noise reduction.
%     
% Output:
%    snake - final snake after full segmentation procedure

displayGraphics = get(handles.checkboxDisplayGraphics,'Value');

[ImCrop xmin ymin] = crop_cell(Im, snake, cropFactor);

snake(:,1) = snake(:,1) - xmin;
snake(:,2) = snake(:,2) - ymin;

if (get(handles.popupmenuMethod,'Value')~=3)
    set(curFigData.status_handle,'String', 'Segmenting - stage 1');
    [snake, nextAvailTag] = GVFsnakeForFullImage(ImCrop, snake, nextAvailTag, handles, curFigData, ...
        'displayGraphics', displayGraphics, 'iterations', iterations, 'edgeSuppresion', edgeSuppresion);
end

if (get(handles.popupmenuMethod,'Value')~=2)
    set(curFigData.status_handle,'String', 'Segmenting - stage 2');
    [snake, nextAvailTag] = GVFsnakeForFullImage(ImCrop,snake, nextAvailTag, handles, curFigData, ...
        'displayGraphics', displayGraphics, 'iterations', iterations,'DirectionalEdgeMap',true , 'edgeSuppresion', edgeSuppresion);
end
snake(:,1) = snake(:,1) + xmin;
snake(:,2) = snake(:,2) + ymin;

end