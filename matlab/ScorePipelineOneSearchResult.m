function varargout = ScorePipelineOneSearchResult(varargin)
% SCOREPIPELINEONESEARCHRESULT MATLAB code for ScorePipeline.fig
%      SCOREPIPELINEONESEARCHRESULT, by itself, creates a new SCOREPIPELINEONESEARCHRESULT or raises the existing
%      singleton*.
%
%      H = SCOREPIPELINEONESEARCHRESULT returns the handle to a new SCOREPIPELINEONESEARCHRESULT or the handle to
%      the existing singleton*.
%
%      SCOREPIPELINEONESEARCHRESULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCOREPIPELINEONESEARCHRESULT.M with the given input arguments.
%
%      SCOREPIPELINEONESEARCHRESULT('Property','Value',...) creates a new SCOREPIPELINEONESEARCHRESULT or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ScorePipeline_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ScorePipeline_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ScorePipeline

% Last Modified by GUIDE v2.5 18-Nov-2016 21:54:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScorePipelineOneSearchResult_OpeningFcn, ...
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
function ScorePipelineOneSearchResult_OpeningFcn(hObject, eventdata, handles, varargin)
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

comment = ScoreQueryRun(['SELECT SearchResult.Comment FROM [SearchResult] WHERE SearchResultId = ' num2str(handles.SearchResultId)]);
filesNotTested = ScoreQueryRun(['SELECT COUNT([SearchResult_Study].[SearchResultStudyId]) FROM [SearchResult_Study] WHERE FileState=0 AND SearchResultId = ' num2str(handles.SearchResultId)]);
filesTested = ScoreQueryRun(['SELECT COUNT([SearchResult_Study].[SearchResultStudyId]) FROM [SearchResult_Study] WHERE FileState<>0 AND SearchResultId = ' num2str(handles.SearchResultId)]);
filesFound = ScoreQueryRun(['SELECT COUNT([SearchResult_Study].[SearchResultStudyId]) FROM [SearchResult_Study] WHERE FileState=1 AND SearchResultId = ' num2str(handles.SearchResultId)]);
filesMissing = ScoreQueryRun(['SELECT COUNT([SearchResult_Study].[SearchResultStudyId]) FROM [SearchResult_Study] WHERE FileState=-1 AND SearchResultId = ' num2str(handles.SearchResultId)]);

colNames = {'Parameter' 'Value'};
data = ['Comment' comment;...
    'Files not tested' filesNotTested; ...
    'Files tested' filesTested; ...
    'Files found' filesFound; ...
    'Files missing' filesMissing ...
    ];
set(handles.searchResultsTable,'data',data,'ColumnName',colNames);

% Choose default command line output for ScorePipeline
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes ScorePipeline wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (hObject == handles.english)
    set(handles.text4, 'String', 'lb/cu.in');
    set(handles.text5, 'String', 'cu.in');
    set(handles.text6, 'String', 'lb');
else
    set(handles.text4, 'String', 'kg/cu.m');
    set(handles.text5, 'String', 'cu.m');
    set(handles.text6, 'String', 'kg');
end

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

h = msgbox({'This must be manually using SQL for now.' 'See the script "3-ExtractFindings.sql" for an example  '});


% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = msgbox({'This must be manually in the database for now.' 'Delete a row in the SearchResult table.'});


% --- Executes on button press in updateFoundFiles.
function updateFoundFiles_Callback(hObject, eventdata, handles)
% hObject    handle to updateFoundFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = msgbox({'Not implemented yet.'});
