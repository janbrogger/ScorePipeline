function varargout = ScorePipeline(varargin)
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
%      applied to the GUI before ScorePipeline_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ScorePipeline_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ScorePipeline

% Last Modified by GUIDE v2.5 02-Apr-2017 21:54:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScorePipeline_OpeningFcn, ...
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
function ScorePipeline_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScorePipeline (see VARARGIN)


ScorePrintHeader();
disp('Reading ScoreConfig.m');
if not(exist('ScoreConfig.m', 'file'))
        error('Configuration file ScoreConfig.m file not found in Matlab path');
end
setdbprefs('datareturnformat','table')
ScoreConfig;
if not(exist(ScoreConfig.scoreBasePath, 'dir'))
    warning(['Fix your ScoreConfig.m file - the SCORE base path was not found: ' ScoreConfig.scoreBasePath]);    
    data = {'ERROR' 'Fix your ScoreConfig.m file ' ;
         'ERROR' ['SCORE base path not found: ' ScoreConfig.scoreBasePath];
       };
   set(handles.searchResultsTable,'data',data);
   
else    
    disp('Adding directories to matlab path if needed');
    ScoreFixMatlabPaths();
    disp('Setting session objects');
    ScoreSession;
    %This next line will output only if ScoreConfig.debug == 1
    ScoreDebugLog('Verbose output for debugging is ON');
    ScoreVerifyRequirements();
    [scoreUserId, scoreUserName] = ScoreGetCurrentUser(0);
    if isempty(scoreUserId) || isempty(scoreUserName)
        uiwait(ScoreSelectUser());
    end
    
    disp(['Current SCORE user is:' scoreUserName ' (UserId: ' num2str(scoreUserId) ')']);
    UpdateTable(handles);
end

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

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
    
% Update handles structure

guidata(handles.figure1, handles);

function UpdateTable(handles)
    searchResultsQuery = [...    
    'SELECT [SearchResult].SearchResultId, [SearchResult].Comment , COUNT(SearchResult_Study.SearchResultStudyId) AS b_count ,[User].UserName ' ...
    'FROM [SearchResult]   ' ...
    'LEFT JOIN SearchResult_Study on [SearchResult].SearchResultId = SearchResult_Study.SearchResultId  '   ...  
    'LEFT JOIN [User] on [SearchResult].UserId = [User].UserId '     ...
    'GROUP BY SearchResult.SearchResultId, SearchResult.Comment, [User].UserName ' ...
    'ORDER BY SearchResult.SearchResultId '
    ];

    colNames = {'Id', 'Comment', '# of studies', 'User'};
    data = ScoreQueryRun(searchResultsQuery);
    if strcmp(data,'No Data') == 0 && istable(data)
        set(handles.searchResultsTable,'data',table2cell(data),'ColumnName',colNames);
    else
        set(handles.searchResultsTable,'data',[],'ColumnName',colNames);
    end    

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
if isfield(handles, 'datatable_row')
    tableData = get(handles.searchResultsTable, 'data');
    searchResultId = tableData{handles.datatable_row,1};
    ScoreDeleteSearchResult(searchResultId);
    UpdateTable(handles);
else
    msgbox({'Select an item first.'});
end


% --- Executes on button press in openButton.
function openButton_Callback(hObject, eventdata, handles)
% hObject    handle to openButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%h = msgbox({'Not implemented yet.'});
if isfield(handles, 'datatable_row')
    tableData = get(handles.searchResultsTable, 'data');
    searchResultId = tableData{handles.datatable_row,1};
    ScoreSearchResultDetail(searchResultId);
else
    msgbox({'Select an item first.'});
end


% --- Executes when selected cell(s) is changed in searchResultsTable.
function searchResultsTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to searchResultsTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    handles.datatable_row = eventdata.Indices(1);
else
    handles.datatable_row = [];
end    
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in subsample.
function subsample_Callback(hObject, eventdata, handles)
% hObject    handle to subsample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'datatable_row')
    tableData = get(handles.searchResultsTable, 'data');
    searchResultId = tableData{handles.datatable_row,1};
else
    msgbox({'Select an item first.'});
end


numberToSample = inputdlg('Enter a number to sample', 'Subsample search results',1 );
if ~isempty(numberToSample)
    numberToSample = str2num(numberToSample{1});
    if isempty(numberToSample)
        warning('Entry is not a number')
    else
        ScoreSubsampleProject(searchResultId, numberToSample);
        UpdateTable(handles);
    end
else
    warning('Nothing was entered')
end
