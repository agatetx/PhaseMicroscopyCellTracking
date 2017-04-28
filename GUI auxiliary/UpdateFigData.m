function curFigData = UpdateFigData(handles, curFigData, tracking)
% 
% curFigData = UpdateFigData(handles, curFigData, tracking)
% 
% the function updates the GUI with the current axes.
% 
% input: 
%     handles - standarts GUI handles array.   
%     curFigData - contain information regarding plots demanded by GUI.
%     tracking - flag which says if we are in tracking mode. 
% 
% output:
%     curFigData - contain update information regarding plots demanded by GUI.
%     
%     
%     
    
if(nargin > 2)
    curFigData.figure_handle = handles.figureMain;
    if(tracking)
        curFigData.status_handle = handles.textTrackingStatus;
        curFigData.axes_handle = handles.plotTracking;
    else
        curFigData.status_handle = handles.textTestStatus;
        curFigData.axes_handle = handles.plotSegmentationTest;
    end
end

curFigData.extra_data_axes = [];

strList = get(handles.popupmenuED4, 'String');
str = strrep(strList{get(handles.popupmenuED4, 'Value')}, ' ', '_');
curFigData.extra_data_axes = setfield(curFigData.extra_data_axes, str, handles.axesED4);

strList = get(handles.popupmenuED3, 'String');
str = strrep(strList{get(handles.popupmenuED3, 'Value')}, ' ', '_');
curFigData.extra_data_axes = setfield(curFigData.extra_data_axes, str, handles.axesED3);

strList = get(handles.popupmenuED2, 'String');
str = strrep(strList{get(handles.popupmenuED2, 'Value')}, ' ', '_');
curFigData.extra_data_axes = setfield(curFigData.extra_data_axes, str, handles.axesED2);

strList = get(handles.popupmenuED1, 'String');
str = strrep(strList{get(handles.popupmenuED1, 'Value')}, ' ', '_');
curFigData.extra_data_axes = setfield(curFigData.extra_data_axes, str, handles.axesED1);