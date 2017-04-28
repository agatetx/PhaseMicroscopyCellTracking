

function varargout = CellTrackingGui(varargin)
% CellTrackingGui M-file for CellTrackingGui.fig
%      CellTrackingGui, by itself, creates a new CellTrackingGui or raises the existing
%      singleton*.
%
%      H = CellTrackingGui returns the handle to a new CellTrackingGui or the handle to
%      the existing singleton*.
%
%      CellTrackingGui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CellTrackingGui.M with the given input arguments.
%
%      CellTrackingGui('Property','Value',...) creates a new CellTrackingGui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CellTrackingGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CellTrackingGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CellTrackingGui

% Last Modified by GUIDE v2.5 28-Dec-2010 16:54:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CellTrackingGui_OpeningFcn, ...
                   'gui_OutputFcn',  @CellTrackingGui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before CellTrackingGui is made visible.
function CellTrackingGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CellTrackingGui (see VARARGIN)

% Choose default command line output for CellTrackingGui
handles.output = hObject;
handles.global.seg_img = 0;
handles.global.AbortTracking = false;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CellTrackingGui wait for user response (see UIRESUME)
% uiwait(handles.figureMain);

% if avaluable, load last parameter configuration
checkboxDisplayGraphics_Callback(hObject, eventdata, handles);






% --- Outputs from this function are returned to the command line.
function varargout = CellTrackingGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonRun.
function pushbuttonRun_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     
     set(handles.pushbuttonTestSeg,'Enable', 'off');
     set(handles.pushbuttonRun,'Enable', 'off');
     set(handles.pushbuttonAbortTracking,'Enable', 'on');

   
     try
         performTrackingMaskExtraction(handles);
     catch exception
         if (strcmp(exception.identifier, 'UserAction:UserHitAbort'))
             set(handles.textTrackingStatus,'String', 'Aborted');
         else
             % Unknown error.
             h = errordlg(sprintf('Error: Tracking or Segmantation has failed.\n\nExtended information:\nIDENTIFIER: %s\nMESSAGE: %s', exception.identifier, exception.message));
             waitfor(h);
             reset_GUI(hObject, eventdata, handles);
             set(handles.pushbuttonTestSeg,'Enable', 'on');
             set(handles.pushbuttonRun,'Enable', 'on');
             set(handles.pushbuttonAbortTracking,'Enable', 'off');
             rethrow(exception);
         end
     end
    
    set(handles.pushbuttonTestSeg,'Enable', 'on');
    set(handles.pushbuttonRun,'Enable', 'on');
    set(handles.pushbuttonAbortTracking,'Enable', 'off');



% --- Executes on selection change in listboxFrameList.
function listboxFrameList_Callback(hObject, eventdata, handles)
% hObject    handle to listboxFrameList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxFrameList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxFrameList
    list = get(handles.listboxFrameList, 'String');
    frame = str2num(list(get(handles.listboxFrameList, 'Value'),:));

    img = load_image(handles, frame);
%     handles.global.seg_img = img;
%     guidata(hObject, handles);
    set(handles.figureMain,'CurrentAxes', handles.plotSegmentationTest)
    imshow(img);


% --- Executes during object creation, after setting all properties.
function listboxFrameList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFrameList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonTestSeg.
function pushbuttonTestSeg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTestSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.pushbuttonTestSeg,'Enable', 'off');
    set(handles.pushbuttonRun,'Enable', 'off');
    try
        preformTestSegmentation(handles);
    catch exception
        h = errordlg(sprintf('Error: Segmentation failed.\n\nExtended information:\nIDENTIFIER: %s\nMESSAGE: %s', exception.identifier, exception.message));
        waitfor(h);
        reset_GUI(hObject, eventdata, handles);
        set(handles.pushbuttonTestSeg,'Enable', 'on');
        set(handles.pushbuttonRun,'Enable', 'on');
        rethrow(exception);
    end
    set(handles.pushbuttonTestSeg,'Enable', 'on');
    set(handles.pushbuttonRun,'Enable', 'on');
    



function editResizeFactor_Callback(hObject, eventdata, handles)
% hObject    handle to editResizeFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResizeFactor as text
%        str2double(get(hObject,'String')) returns contents of editResizeFactor as a double


% --- Executes during object creation, after setting all properties.
function editResizeFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResizeFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCropFactor_Callback(hObject, eventdata, handles)
% hObject    handle to editCropFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCropFactor as text
%        str2double(get(hObject,'String')) returns contents of editCropFactor as a double


% --- Executes during object creation, after setting all properties.
function editCropFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCropFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDilateFactor_Callback(hObject, eventdata, handles)
% hObject    handle to editDilateFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDilateFactor as text
%        str2double(get(hObject,'String')) returns contents of editDilateFactor as a double


% --- Executes during object creation, after setting all properties.
function editDilateFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDilateFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSegIter_Callback(hObject, eventdata, handles)
% hObject    handle to editSegIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSegIter as text
%        str2double(get(hObject,'String')) returns contents of editSegIter as a double


% --- Executes during object creation, after setting all properties.
function editSegIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSegIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEdgeSuppresion_Callback(hObject, eventdata, handles)
% hObject    handle to editEdgeSuppresion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEdgeSuppresion as text
%        str2double(get(hObject,'String')) returns contents of editEdgeSuppresion as a double


% --- Executes during object creation, after setting all properties.
function editEdgeSuppresion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEdgeSuppresion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuSnakeColor.
function popupmenuSnakeColor_Callback(hObject, eventdata, handles)

set(handles.figureMain,'DefaultAxesColorOrder', get_user_color(handles));

% --- Executes during object creation, after setting all properties.
function popupmenuSnakeColor_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function popupmenuMethod_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxDisplayGraphics.
function checkboxDisplayGraphics_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxDisplayGraphics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxDisplayGraphics

if get(handles.checkboxDisplayGraphics, 'Value')
    s = get(handles.figureMain, 'Position');
    set(handles.figureMain, 'Position', [ s(1) s(2) 308.6 s(4)]);
else
    s = get(handles.figureMain, 'Position');
    set(handles.figureMain, 'Position', [ s(1) s(2) 308.6-120 s(4)]);    
end



% --- Executes during object creation, after setting all properties.
function editFileName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function editFolderName_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editInitialFrame_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editFinalFrame_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonBrowse.
function pushbuttonBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir = uigetdir;
if dir ~= 0
    set(handles.editFolderName,'String',[dir '\']);
    editFolderName_Callback(hObject, eventdata, handles);
end;



function status = reset_GUI(hObject, eventdata, handles)
    set(handles.pushbuttonTestSeg,'Enable', 'on');
    set(handles.pushbuttonRun,'Enable', 'on');
    set(handles.figureMain,'DefaultAxesColorOrder', get_user_color(handles));
   
    checkboxDisplayGraphics_Callback(hObject, eventdata, handles)
    status = true;
    try
        init_test_seg_frame(hObject, handles);
        init_tracking_frame(hObject, handles);
    catch exception
        errordlg(sprintf('Error: Unable to initialize sequence.\nPlease assure that path, filename and frame indexes are correct.\n\nExtended information:\nIDENTIFIER: %s\nMESSAGE: %s', exception.identifier, exception.message));
        status = false;
        rethrow(exception);
    end


% --- Executes on button press in pushbuttonLoadSeq.
function pushbuttonLoadSeq_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoadSeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%     close all;
%     clear all;
  

% handles.global.initialFrame = str2num(get(handles.editInitialFrame, 'String'));
% handles.global.finalFrame = str2num(get(handles.editFinalFrame, 'String'));
frames = handles.global.FrameListTmp;

initframe = str2num(get(handles.editInitialFrame,'String'));
finalframe = str2num(get(handles.editFinalFrame,'String'));
if (~any(frames == initframe))
    errordlg(sprintf('Error: this frame does not exist.\nSeqence Initialization failed'));
    return;
end

handles.global.fileName = get(handles.editFileName, 'String');
handles.global.folderName = get(handles.editFolderName, 'String');
handles.global.FrameList = frames((initframe <= frames)&(finalframe >= frames));

% Update handles structure
guidata(hObject, handles);

reset_GUI(hObject, eventdata, handles)
helpdlg('Sequence initilized succesfully! ENJOY');

    

% --- Executes when user attempts to close figureMain.
function figureMain_CloseRequestFcn(hObject, eventdata, handles)
% set(handles.figureMain,'CurrentAxes', handles.plotTracking); cla;
% set(handles.figureMain,'CurrentAxes', handles.plotSegmentationTest); cla;
set(handles.figureMain,'CurrentAxes', handles.axesED1); cla;
set(handles.figureMain,'CurrentAxes', handles.axesED2); cla;
set(handles.figureMain,'CurrentAxes', handles.axesED3); cla;
set(handles.figureMain,'CurrentAxes', handles.axesED4); cla;
    choice = questdlg('Would you like to save workspace for future use?', 'Save', ...
        'Yes', 'No', 'Yes');
    % Handle response
    if(strcmp(choice, 'Yes'))
        h = helpdlg('Closing application and saving workspace...');
        set(h, 'WindowStyle', 'modal');
        hgsave(handles.figureMain,'autosave');
        close(h);
        delete(hObject);
    elseif(strcmp(choice, 'No'))
        delete(hObject);   
    end

% Hint: delete(hObject) closes the figure



% --- Executes on button press in pushbuttonAbortTracking.
function pushbuttonAbortTracking_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAbortTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pushbuttonAbortTracking,'String', 'Aborting...');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenuED3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenuED1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function popupmenuED2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuED2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenuED4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonZoomED1.
function pushbuttonZoomED1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonZoomED1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = figure(1); clf;
new_handle = copyobj(get(handles.axesED1,'Children'),gca);
title(get(get(handles.axesED1,'title'),'String'));
set(h,'colormap', get(handles.figureMain, 'colormap'));
set(gca,'XDir', get(handles.axesED1, 'XDir'));
set(gca,'YDir', get(handles.axesED1, 'YDir'));
axis image;
xlabel('close the window to continue...')
drawnow;
waitfor(h);

% --- Executes on button press in pushbuttonZoomED2.
function pushbuttonZoomED2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonZoomED2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = figure(2); clf;
new_handle = copyobj(get(handles.axesED2,'Children'),gca);
title(get(get(handles.axesED2,'title'),'String'));

set(h,'colormap', get(handles.figureMain, 'colormap'));
set(gca,'XDir', get(handles.axesED2, 'XDir'));
set(gca,'YDir', get(handles.axesED2, 'YDir'));
axis image;
drawnow;
waitfor(h);

% --- Executes on button press in pushbuttonZoomED3.
function pushbuttonZoomED3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonZoomED3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = figure(3); clf;
new_handle = copyobj(get(handles.axesED3,'Children'),gca);
title(get(get(handles.axesED3,'title'),'String'));

set(h,'colormap', get(handles.figureMain, 'colormap'));
set(gca,'XDir', get(handles.axesED3, 'XDir'));
set(gca,'YDir', get(handles.axesED3, 'YDir'));
axis image;
drawnow;
waitfor(h);

% --- Executes on button press in pushbuttonZoomED4.
function pushbuttonZoomED4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonZoomED4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = figure(4); clf;
new_handle = copyobj(get(handles.axesED4,'Children'),gca);
title(get(get(handles.axesED4,'title'),'String'));

set(h,'colormap', get(handles.figureMain, 'colormap'));
set(gca,'XDir', get(handles.axesED4, 'XDir'));
set(gca,'YDir', get(handles.axesED4, 'YDir'));
axis image;
drawnow;
waitfor(h);


% --- Executes during object creation, after setting all properties.
function popupmenuImageCoding_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editInitialFrame_Callback(hObject, eventdata, handles)
% hObject    handle to editInitialFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editInitialFrame as text
%        str2double(get(hObject,'String')) returns contents of editInitialFrame as a double




function editFinalFrame_Callback(hObject, eventdata, handles)
% hObject    handle to editFinalFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFinalFrame as text
%        str2double(get(hObject,'String')) returns contents of editFinalFrame as a double



function editFolderName_Callback(hObject, eventdata, handles)
% hObject    handle to editFolderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  
dir_name = get(handles.editFolderName,'String');
[initNum,endNum,file_numbers,name,fullList] = inputParams(dir_name);
handles.global.FrameListTmp = file_numbers;
   
set(handles.editFileName,'String',name);
set(handles.editFileName,'String',name);
set(handles.editInitialFrame,'String',initNum);
set(handles.editFinalFrame,'String',endNum);
if fullList==0
    warndlg(sprintf('Warning: There are some missing frames in the folder.\nThe tracking procedure might fail when it reaches them.'));
% Hints: get(hObject,'String') returns contents of editFolderName as text
%        str2double(get(hObject,'String')) returns contents of editFolderName as a double
end
 % Update handles structure
guidata(hObject, handles);

function editFileName_Callback(hObject, eventdata, handles)
% hObject    handle to editFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFileName as text
%        str2double(get(hObject,'String')) returns contents of editFileName as a double


% --- Executes on selection change in popupmenuMethod.
function popupmenuMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuMethod


% --- Executes on button press in checkboxSaveImages.
function checkboxSaveImages_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSaveImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveImages


% --- Executes on button press in checkboxSaveMovie.
function checkboxSaveMovie_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSaveMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaveMovie


% --- Executes on selection change in popupmenuImageCoding.
function popupmenuImageCoding_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuImageCoding (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuImageCoding contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuImageCoding


% --- Executes on selection change in popupmenuED1.
function popupmenuED1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuED1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuED1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuED1


% --- Executes on selection change in popupmenuED2.
function popupmenuED2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuED2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuED2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuED2


% --- Executes on selection change in popupmenuED3.
function popupmenuED3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuED3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuED3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuED3


% --- Executes on selection change in popupmenuED4.
function popupmenuED4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuED4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuED4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuED4


% --- Executes on button press in checkboxUseSigmodial.
function checkboxUseSigmodial_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxUseSigmodial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxUseSigmodial


% --- Executes on button press in pushbuttonPause.
function pushbuttonPause_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiwait(warndlg('Program execution suspended. Click OK to continue...','modal'));


% --- Executes on button press in pushbuttonPause.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonHelp.
function pushbuttonHelp_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open('Manual.pdf');


% --- Executes on button press in pushbuttonAbout.
function pushbuttonAbout_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAbout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

About();