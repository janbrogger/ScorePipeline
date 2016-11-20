function varargout = ScoreSearchResultDetail(varargin)
% SCOREPIPELINE MATLAB code for ScorePipeline.fig
%      SCOREPIPELINE, by itself, creates a new SCOREPIPELINE or raises the existing
%      singleton*.
%
%      H = SCOREPIPELINE returns the handle to a new SCOREPIPELINE or the handle to
%      the existing singleton*.
%
%      SCOREPIPELINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCOREPIPELINE.M with the given input arguments.
%
%      SCOREPIPELINE('Property','Value',...) creates a new SCOREPIPELINE or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ScoreSearchResultDetail_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ScoreSearchResultDetail_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ScorePipeline

% Last Modified by GUIDE v2.5 20-Nov-2016 13:51:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScoreSearchResultDetail_OpeningFcn, ...
                   'gui_OutputFcn',  @ScorePipeline_OutputFcn, ...
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

% --- Executes just before ScorePipeline is made visible.
function ScoreSearchResultDetail_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScorePipeline (see VARARGIN)

handles.SearchResultId = -1; 
if nargin<4 
      handles.SearchResultId = -1;
else
      handles.SearchResultId = varargin{1};
end

if (handles.SearchResultId == -1)
    error('Cannot show search result details, no argument given');
end

UpdateInfo(handles);
% Choose default command line output for ScorePipeline
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes ScorePipeline wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function UpdateInfo(handles)
comment = ScoreQueryRun(['SELECT SearchResult.Comment FROM [SearchResult] WHERE SearchResultId = ' num2str(handles.SearchResultId)]);
filesNotTested = ScoreQueryRun(['SELECT COUNT([SearchResult_Study].[SearchResultStudyId]) FROM [SearchResult_Study] WHERE FileState=0 AND SearchResultId = ' num2str(handles.SearchResultId)]);
filesTested = ScoreQueryRun(['SELECT COUNT([SearchResult_Study].[SearchResultStudyId]) FROM [SearchResult_Study] WHERE FileState<>0 AND SearchResultId = ' num2str(handles.SearchResultId)]);
filesFound = ScoreQueryRun(['SELECT COUNT([SearchResult_Study].[SearchResultStudyId]) FROM [SearchResult_Study] WHERE FileState=1 AND SearchResultId = ' num2str(handles.SearchResultId)]);
filesMissing = ScoreQueryRun(['SELECT COUNT([SearchResult_Study].[SearchResultStudyId]) FROM [SearchResult_Study] WHERE FileState=-1 AND SearchResultId = ' num2str(handles.SearchResultId)]);
workstateNotStarted = ScoreWorkstateCount(handles.SearchResultId, 0);
workstateInvalid = ScoreWorkstateCount(handles.SearchResultId, -1);
workstateInProgress = ScoreWorkstateCount(handles.SearchResultId, 1);
workstateCompleted = ScoreWorkstateCount(handles.SearchResultId, 2);

colNames = {'Parameter' 'Value'};
data = ['Comment' comment;...
    'Files not tested' filesNotTested; ...
    'Files tested' filesTested; ...
    'Files found' filesFound; ...
    'Files missing' filesMissing; ...
    'Work state not started' workstateNotStarted; ...
    'Work state invalid' workstateInvalid; ...
    'Work state in progress' workstateInProgress; ...
    'Work state completed' workstateCompleted ...
    ];
set(handles.searchResultProperties,'data',data,'ColumnName',colNames);

% --- Outputs from this function are returned to the command line.
function varargout = ScorePipeline_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function density_Callback(hObject, eventdata, handles)
% hObject    handle to density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of density as text
%        str2double(get(hObject,'String')) returns contents of density as a double
density = str2double(get(hObject, 'String'));
if isnan(density)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new density value
handles.metricdata.density = density;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volume as text
%        str2double(get(hObject,'String')) returns contents of volume as a double
volume = str2double(get(hObject, 'String'));
if isnan(volume)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new volume value
handles.metricdata.volume = volume;
guidata(hObject,handles)

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mass = handles.metricdata.density * handles.metricdata.volume;
set(handles.mass, 'String', mass);

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
    
% Update handles structure

guidata(handles.figure1, handles);


% --- Executes on selection change in searchResultsListBox.
function searchResultsListBox_Callback(hObject, eventdata, handles)
% hObject    handle to searchResultsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns searchResultsListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from searchResultsListBox


% --- Executes during object creation, after setting all properties.
function searchResultsListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchResultsListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = msgbox({'Not implemented'});


% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = msgbox({'Not implemented'});


% --- Executes on button press in updateFiles.
function updateFiles_Callback(hObject, eventdata, handles)
% hObject    handle to updateFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%h = msgbox({'Not implemented yet.'});

t1 = timer();
set(t1,...
    'Name','UpdateFilesInfoTimer', ...
    'TimerFcn', @(~,~) UpdateFilesTimerTick(handles), ...
    'ExecutionMode','fixedSpacing', ...
    'Period', 1, ...    
    'BusyMode', 'drop')
start(t1);
%pause(5);
%Do expensive stuff here
resetfileStatusQuery = ['UPDATE [dbo].[SearchResult_Study] SET FileState = 0 WHERE SearchResultId=' num2str(handles.SearchResultId)];  
ScoreQueryRun(resetfileStatusQuery);  
ScoreCheckStudyFiles(handles.SearchResultId);
stop(t1);
delete(t1);
UpdateFilesTimerTick(handles);


function UpdateFilesTimerTick(handles)
UpdateInfo(handles);
drawnow();