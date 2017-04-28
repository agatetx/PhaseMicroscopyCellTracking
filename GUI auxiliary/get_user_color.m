function col = get_user_color(handles)
% 
% col = get_user_color(handles)
% 
% A GUI helper function to read snake color
% selected by the user in the GUI listbox
% 
% input:
%     handles - standard GUI handles array
%     
% output:
%     col - a [r g b] structure indicating the selected color
%     

colorList = get(handles.popupmenuSnakeColor, 'UserData');
col = colorList(get(handles.popupmenuSnakeColor, 'Value'), :);