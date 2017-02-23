function varargout = ScoreSearchResultDetailAnnotationConfig(varargin)
% ScoreSearchResultDetailAnnotationConfig
%   Displays configuration details for one SCORE project.
%   Syntax: 
%     ScoreSearchResultDetailAnnotationConfig(
%       searchResultId)
%   -searchResultId : an entry in SearchResult table

% Edit the above text to modify the response to help ScoreSearchResultDetailAnnotationConfig

% Last Modified by GUIDE v2.5 23-Feb-2017 20:39:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScoreSearchResultDetailAnnotationConfig_OpeningFcn, ...
                   'gui_OutputFcn',  @ScoreSearchResultDetailAnnotationConfig_OutputFcn, ...
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

% --- Executes just before ScoreSearchResultDetailAnnotationConfig is made visible.
function ScoreSearchResultDetailAnnotationConfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScoreSearchResultDetailAnnotationConfig (see VARARGIN)

% Choose default command line output for ScoreSearchResultDetailAnnotationConfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

if(size(varargin, 1) >= 1)
    handles.SearchResultId = varargin{1};           
    guidata(hObject, handles);
else
    error('No SearchResultId specified');
end

UpdateInfo(handles);

% UIWAIT makes ScoreSearchResultDetailAnnotationConfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function UpdateInfo(handles)

colNames = {'Id', 'Field name' , 'Comment'};
set(handles.configTable,'ColumnName',colNames);

configData = ScoreGetAnnotationsForOneProject(handles.SearchResultId);
if ~strcmp(configData,'No Data')
    configData2 = configData(:,{'SearchResultAnnotationConfigId', 'FieldName', 'FieldComment'});
    set(handles.configTable,'Data',table2cell(configData2));
else
    set(handles.configTable,'Data',[]);
end    


% --- Outputs from this function are returned to the command line.
function varargout = ScoreSearchResultDetailAnnotationConfig_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end


% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ScoreSearchResultDetailAnnotationConfigOne(handles.SearchResultId);
UpdateInfo(handles);


% --- Executes on button press in deleteButton.
function deleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'rowselection') && ~isempty(handles.rowselection)
    tableData = get(handles.configTable, 'data');
    searchResultConfigId = tableData{handles.rowselection,1};
    try
        ScoreDeleteAnnotationConfig(searchResultConfigId);
    catch
        msgbox({'Failed to delete. Perhaps it is in use?'});
    end
    UpdateInfo(handles);
else
    msgbox({'Select an item first.'});
end


% --- Executes on button press in editButton.
function editButton_Callback(hObject, eventdata, handles)
% hObject    handle to editButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'rowselection') && ~isempty(handles.rowselection)
    tableData = get(handles.configTable, 'data');
    searchResultConfigId = tableData{handles.rowselection,1};
    ScoreSearchResultDetailAnnotationConfigOne(handles.SearchResultId, searchResultConfigId);
    UpdateInfo(handles);
else
    msgbox({'Select an item first.'});
end


% --- Executes when selected cell(s) is changed in configTable.
function configTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to configTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(eventdata.Indices)
    handles.rowselection = eventdata.Indices(1);
else
    handles.rowselection = [];
end    
guidata(hObject, handles);
