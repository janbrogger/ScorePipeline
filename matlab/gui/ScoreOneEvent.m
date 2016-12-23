function varargout = ScoreOneEvent(varargin)
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

% Last Modified by GUIDE v2.5 23-Nov-2016 16:13:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScoreOneEvent_OpeningFcn, ...
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
function ScoreOneEvent_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScorePipeline (see VARARGIN)

handles.SearchResultId = -1; 
handles.SearchResultEventId = -1; 
if nargin<4 
      handles.SearchResultId = -1;
else
      handles.SearchResultId = varargin{1};
end

if nargin<5
      handles.SearchResultEventId = -1;
else
      handles.SearchResultEventId = varargin{2};
end

if (handles.SearchResultId == -1)
    error('Cannot show one event details, no search result ID given');
else
    searchResultTestQuery = ScoreQueryRun(['SELECT * FROM SearchResult WHERE SearchResult.SearchResultId = ' num2str(handles.SearchResultId)]);
    if strcmp(searchResultTestQuery, 'No Data')
        error(['SearchResult.SearchResultId=' num2str(handles.SearchResultId) ' not found']);
    end
end

if not(handles.SearchResultId == -1) && handles.SearchResultEventId == -1    
    searchResultEventId = ScoreQueryRun(['SELECT MIN(SearchResultEventId) FROM SearchResult_Event WHERE SearchResult_Event.SearchResultId = ' num2str(handles.SearchResultId)]);
    handles.SearchResultEventId = searchResultEventId.x;
end

handles.timeSpanMinusGaps = -1;
handles = UpdateInfo(handles);
if handles.FileExists == 1
    SetFileOpenWaitStatus(handles);
    openSuccess = ScoreOpenEegFileInEeglab(handles.FilePath, num2str(handles.SearchResultEventId));         
    if openSuccess
        handles.timeSpanMinusGaps = ScoreGotoEvent(handles.SearchResultEventId); 
    else 
        warning('EEG file open failure');
    end    
    EnableButtonsAfterWait(handles);
    handles = UpdateInfo(handles);
end
% Choose default command line output for ScorePipeline
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes ScorePipeline wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = UpdateInfo(handles)

colNames = {'Parameter' 'Value'};

time = ScoreQueryRun(['SELECT StartDateTime FROM [SearchResult_Event] ' ... 
            ' INNER JOIN Event ON Event.EventId = SearchResult_Event.EventId ' ... 
            ' WHERE SearchResultEventId = ' num2str(handles.SearchResultEventId)]);    
        
searchResultRecordingId = ScoreQueryRun([
        'SELECT MIN(SearchResultRecordingId)  ' ...
        'FROM SearchResult_Event  ' ...
        'INNER JOIN Event ON SearchResult_Event.Eventid = Event.EventId  ' ...
        'INNER JOIN Recording ON Event.RecordingId = Recording.RecordingId  ' ...
        'INNER JOIN SearchResult_Recording ON Recording.RecordingId = SearchResult_Recording.RecordingId  ' ...
        ' WHERE SearchResult_Event.SearchResultEventId =  ' num2str(handles.SearchResultEventId)]);  

handles.SearchResultRecordingId = searchResultRecordingId.x;

[handles.FileExists, handles.FilePath] = ScoreCheckOneRecordingFile(searchResultRecordingId.x);
if handles.FileExists == -1
    fileExistsText = 'EEG FILE NOT FOUND';
elseif handles.FileExists == 1
    fileExistsText = 'EEG file was found';
else
    fileExistsText = 'Unknown file status';
end

eeglabStatus = 'Undefined';
if not(exist('pop_fileio', 'file'))
    eeglabStatus = 'EEGLAB not loaded';
else    
    existingPlot = findobj(0, 'tag', 'EEGPLOT');
    if isempty(existingPlot)
        eeglabStatus = 'EEG plot NOT FOUND';
    else
        eeglabStatus = 'EEG plot found';
    end
end

data = {'SearchResultEventId' handles.SearchResultEventId;
        'Time' time.StartDateTime{1};
        'Time in seconds minus gaps' num2str(handles.timeSpanMinusGaps, '%6.1f');
        'File path' handles.FilePath;
        'File status' fileExistsText;
        'EEGLAB status' eeglabStatus;        
       };

set(handles.oneEventProperties,'data',data,'ColumnName',colNames);



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


% --- Executes on button press in nextButton.
function nextButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nextSearchResultEventId = ScoreQueryRun(['SELECT MIN(SearchResultEventId) FROM SearchResult_Event ' ...
    ' WHERE SearchResult_Event.SearchResultId = ' num2str(handles.SearchResultId) ...
    ' AND SearchResult_Event.SearchResultEventId > ' num2str(handles.SearchResultEventId) ...
    ]);
if not(isnan(nextSearchResultEventId.x))
    handles.SearchResultEventId = nextSearchResultEventId.x;
end

guidata(hObject, handles);
oldSearchResultRecordingId = handles.SearchResultRecordingId;
handles = UpdateInfo(handles);
guidata(hObject, handles);
existingPlot = findobj(0, 'tag', 'EEGPLOT');
if isempty(existingPlot) || (oldSearchResultRecordingId ~= handles.SearchResultRecordingId && handles.FileExists == 1)    
    SetFileOpenWaitStatus(handles);
    openSuccess = ScoreOpenEegFileInEeglab(handles.FilePath, num2str(handles.SearchResultEventId)); 
    if openSuccess
        handles.timeSpanMinusGaps = ScoreGotoEvent(handles.SearchResultEventId); 
    else 
        warning('EEG file open failure');
    end    
    EnableButtonsAfterWait(handles);
else
    ScoreGotoEvent(handles.SearchResultEventId);
end
handles = UpdateInfo(handles);
guidata(hObject, handles);



% --- Executes on button press in backButton.
function backButton_Callback(hObject, eventdata, handles)
% hObject    handle to backButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nextSearchResultEventId = ScoreQueryRun(['SELECT MAX(SearchResultEventId) FROM SearchResult_Event ' ...
    'WHERE SearchResult_Event.SearchResultId = ' num2str(handles.SearchResultId) ...
    'AND SearchResult_Event.SearchResultEventId < ' num2str(handles.SearchResultEventId) ...
    ]);
if not(isnan(nextSearchResultEventId.x))
    handles.SearchResultEventId = nextSearchResultEventId.x;
end

oldSearchResultRecordingId = handles.SearchResultRecordingId;
guidata(hObject, handles);
handles = UpdateInfo(handles);
guidata(hObject, handles);
existingPlot = findobj(0, 'tag', 'EEGPLOT');
if isempty(existingPlot) || (oldSearchResultRecordingId ~= handles.SearchResultRecordingId && handles.FileExists == 1)    
    SetFileOpenWaitStatus(handles);
    openSuccess = ScoreOpenEegFileInEeglab(handles.FilePath, num2str(handles.SearchResultEventId));     
    if openSuccess
        handles.timeSpanMinusGaps = ScoreGotoEvent(handles.SearchResultEventId); 
    else 
        warning('EEG file open failure');
    end    
    EnableButtonsAfterWait(handles);
else
    ScoreGotoEvent(handles.SearchResultEventId);
end
handles = UpdateInfo(handles);
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in oneEventProperties.
function oneEventProperties_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to oneEventProperties (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


function SetFileOpenWaitStatus(handles)
colNames = {'Status' };
data = {'Waiting for file to open' };
set(handles.oneEventProperties,'data',data,'ColumnName',colNames);
set(handles.openButton,'Enable','off') 
set(handles.nextButton,'Enable','off') 
set(handles.backButton,'Enable','off') 
drawnow();

function EnableButtonsAfterWait(handles)
set(handles.nextButton,'Enable','on');
set(handles.backButton,'Enable','on'); 
set(handles.openButton,'Enable','on');