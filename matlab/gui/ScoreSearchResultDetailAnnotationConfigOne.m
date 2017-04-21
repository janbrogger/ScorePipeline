function varargout = ScoreSearchResultDetailAnnotationConfigOne(varargin)
% ScoreSearchResultDetailAnnotationConfigOne
%   Displays details for one SCORE event in the SCORE pipeline.
%   Syntax: 
%     ScoreSearchResultDetailAnnotationConfigOne(
%       searchResultId, SearchResultAnnotationConfigId)
%   -searchResultId : an entry in SearchResult table
%   -optional: SearchResultAnnotationConfigId : an entry in the 
%              SearchResult_AnnotationConfig table to edit
% Last Modified by GUIDE v2.5 23-Feb-2017 13:27:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScoreSearchResultDetailAnnotationConfigOne_OpeningFcn, ...
                   'gui_OutputFcn',  @ScoreSearchResultDetailAnnotationConfigOne_OutputFcn, ...
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

% --- Executes just before ScoreSearchResultDetailAnnotationConfigOne is made visible.
function ScoreSearchResultDetailAnnotationConfigOne_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScoreSearchResultDetailAnnotationConfigOne (see VARARGIN)

% Choose default command line output for ScoreSearchResultDetailAnnotationConfigOne
handles.output = 'Yes';

% Update handles structure
guidata(hObject, handles);

if(size(varargin, 2) >= 1)
    handles.SearchResultId = varargin{1};
     set(handles.title,'String', 'Add an annotation config');
else
    error('Argument SearchResultId (project ID) not specified.');
end    

if(size(varargin, 2) >= 2)
    handles.SearchResultAnnotationConfigId = varargin{2};   
    set(handles.title,'String', 'Edit an annotation config');
    existingData = ScoreGetAnnotationConfig(handles.SearchResultAnnotationConfigId);    
    set(handles.fieldName,'String',existingData.FieldName);
    set(handles.fieldComment,'String',existingData.FieldComment);
    if (existingData.HasInteger == 1)
        set(handles.dataTypeGroup,'SelectedObject',handles.dataTypeInteger);
    end
    if (existingData.HasFloat == 1)
        set(handles.dataTypeGroup,'SelectedObject',handles.dataTypeFloat);
    end
    if (existingData.HasString == 1)
        set(handles.dataTypeGroup,'SelectedObject',handles.dataTypeString);
    end
    if (existingData.HasBit == 1)
        set(handles.dataTypeGroup,'SelectedObject',handles.dataTypeBit);
    end
end
guidata(hObject, handles);

% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
load dialogicons.mat

IconData=questIconData;
questIconMap(256,:) = get(handles.scoreSearchResultDetailAnnotationConfigOne, 'Color');
IconCMap=questIconMap;

set(handles.scoreSearchResultDetailAnnotationConfigOne, 'Colormap', IconCMap);


% Make the GUI modal
set(handles.scoreSearchResultDetailAnnotationConfigOne,'WindowStyle','modal')

% UIWAIT makes ScoreSearchResultDetailAnnotationConfigOne wait for user response (see UIRESUME)
uiwait(handles.scoreSearchResultDetailAnnotationConfigOne);

% --- Outputs from this function are returned to the command line.
function varargout = ScoreSearchResultDetailAnnotationConfigOne_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.scoreSearchResultDetailAnnotationConfigOne);

% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.scoreSearchResultDetailAnnotationConfigOne);

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hasInteger = 0;
if get(handles.dataTypeGroup,'SelectedObject') == handles.dataTypeInteger
    hasInteger = 1;
end
hasFloat = 0;
if get(handles.dataTypeGroup,'SelectedObject') == handles.dataTypeFloat
    hasFloat = 1;
end
hasString = 0;
if get(handles.dataTypeGroup,'SelectedObject') == handles.dataTypeString
    hasString = 1;
end
hasBit = 0;
if get(handles.dataTypeGroup,'SelectedObject') == handles.dataTypeBit
    hasBit = 1;
end
if isfield(handles, 'SearchResultAnnotationConfigId') && ~isempty(handles.SearchResultAnnotationConfigId)    
    ScoreSetAnnotationConfig(handles.SearchResultAnnotationConfigId, ... 
        get(handles.fieldName,'String'), ...
        get(handles.fieldComment,'String'), ...
        hasInteger, hasFloat, hasString, hasBit);
else
    ScoreCreateAnnotationConfig(handles.SearchResultId, ...
        get(handles.fieldName,'String'), ...
        get(handles.fieldComment,'String'), ...
        hasInteger, hasFloat, hasString, hasBit);
end

handles.output = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.scoreSearchResultDetailAnnotationConfigOne);


% --- Executes when user attempts to close scoreSearchResultDetailAnnotationConfigOne.
function scoreSearchResultDetailAnnotationConfigOne_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to scoreSearchResultDetailAnnotationConfigOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press over scoreSearchResultDetailAnnotationConfigOne with no controls selected.
function scoreSearchResultDetailAnnotationConfigOne_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to scoreSearchResultDetailAnnotationConfigOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.scoreSearchResultDetailAnnotationConfigOne);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.scoreSearchResultDetailAnnotationConfigOne);
end    



function fieldName_Callback(hObject, eventdata, handles)
% hObject    handle to fieldName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldName as text
%        str2double(get(hObject,'String')) returns contents of fieldName as a double


% --- Executes during object creation, after setting all properties.
function fieldName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fieldComment_Callback(hObject, eventdata, handles)
% hObject    handle to fieldComment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldComment as text
%        str2double(get(hObject,'String')) returns contents of fieldComment as a double


% --- Executes during object creation, after setting all properties.
function fieldComment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldComment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
