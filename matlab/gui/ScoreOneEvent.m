function varargout = ScoreOneEvent(varargin)
% ScoreOneEvent MATLAB code for ScoreOneEvent.fig
%   Displays details for one SCORE event in the SCORE pipeline.
%   Syntax: ScoreOneEvent(searchResultId, searchResult_EventId, autoOpen)
%   -searchResultId : an entry in SearchResult table
%   -searchResult_EventIdId : an entry in SearchResult_Event table
%   -autoOpen : automatically open the EEG file (default: on).
%
%
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

if nargin<5
      handles.SearchResultEventId = -1;
else
      handles.SearchResultEventId = varargin{2};
end

if nargin<6
    set(findobj('tag','autoOpenCheckbox'),'value', 1)
else    
    set(findobj('tag','autoOpenCheckbox'),'value', varargin{3})
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

oldSearchResultRecordingId = handles.SearchResultRecordingId;
%CheckOpenEEG(hObject, handles, oldSearchResultRecordingId);

% Choose default command line output for ScorePipeline
handles.output = hObject;

handles = StartScaleTimer(hObject, handles);
set(handles.verticalScaleMenu,'String',char('Undefined', '10', '20', '30', '40', '50', '70', '100', '200', '300', '500', '700', '1000', '2000'));

% Update handles structure
guidata(hObject, handles);
initialize_gui(hObject, handles, false);

% UIWAIT makes ScorePipeline wait for user response (see UIRESUME)
% uiwait(handles.oneEventDetails);

function StopScaleTimerIfExist(hObject, handles)
if isfield(handles, 'UpdateScaleInfoTimer')
    stop(handles.UpdateScaleInfoTimer);
    delete(handles.UpdateScaleInfoTimer);
end    

function handles = StartScaleTimer(hObject, handles)
StopScaleTimerIfExist(hObject, handles);
handles.UpdateScaleInfoTimer = timer();
set(handles.UpdateScaleInfoTimer,...
    'Name','UpdateScaleInfoTimer', ...
    'TimerFcn', @(x,y)UpdateScaleInfo(), ...
    'ExecutionMode','fixedSpacing', ...
    'Period', 1, ...    
    'BusyMode', 'drop');
guidata(hObject, handles);
start(handles.UpdateScaleInfoTimer);

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
    elseif size(existingPlot,1) == 1
        eeglabStatus = 'EEG plot found';
    elseif size(existingPlot,1) >1
        eeglabStatus = 'EEG plot found';
    else
        eeglabStatus = 'EEG plot NOT found';
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



% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
    
% Update handles structure

guidata(handles.oneEventDetails, handles);


% --- Executes on button press in nextButton.
function nextButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nextSearchResultEventId = ScoreQueryRun(['SELECT MIN(SearchResultEventId) FROM SearchResult_Event ' ...
    ' WHERE SearchResult_Event.SearchResultId = ' num2str(handles.SearchResultId) ...
    ' AND SearchResult_Event.SearchResultEventId > ' num2str(handles.SearchResultEventId) ...
    ]);
oldSearchResultRecordingId = handles.SearchResultRecordingId;
if not(isnan(nextSearchResultEventId.x))
    handles.SearchResultEventId = nextSearchResultEventId.x;
    handles = UpdateInfo(handles);
    guidata(hObject, handles);
    CheckOpenEEG(hObject, handles, oldSearchResultRecordingId);
end

% --- Executes on button press in backButton.
function backButton_Callback(hObject, eventdata, handles)
% hObject    handle to backButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

nextSearchResultEventId = ScoreQueryRun(['SELECT MAX(SearchResultEventId) FROM SearchResult_Event ' ...
    'WHERE SearchResult_Event.SearchResultId = ' num2str(handles.SearchResultId) ...
    'AND SearchResult_Event.SearchResultEventId < ' num2str(handles.SearchResultEventId) ...
    ]);
oldSearchResultRecordingId = handles.SearchResultRecordingId;
if not(isnan(nextSearchResultEventId.x))
    handles.SearchResultEventId = nextSearchResultEventId.x;
    handles = UpdateInfo(handles);
    guidata(hObject, handles);    
    CheckOpenEEG(hObject, handles, oldSearchResultRecordingId);
end


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


function openButton_Callback(hObject, eventdata, handles)
OpenEEG(hObject, handles);
handles = StartScaleTimer(hObject, handles);



function CheckOpenEEG(hObject, handles, oldSearchResultRecordingId)

existingPlot = ScoreGetEeglabPlot();
if get(findobj('tag','autoOpenCheckbox'),'value') && (isempty(existingPlot) || (oldSearchResultRecordingId ~= handles.SearchResultRecordingId && handles.FileExists == 1))
    OpenEEG(hObject, handles);
end
if get(findobj('tag','autoOpenCheckbox'),'value') == 0
    existingPlot = findobj(0, 'tag', 'EEGPLOT');
    if not(isempty(existingPlot))
        close(existingPlot.Number)
    end
end
    

function OpenEEG(hObject, handles)
SetFileOpenWaitStatus(handles);
openSuccess = ScoreOpenEegFileInEeglab(handles.FilePath, num2str(handles.SearchResultEventId)); 
if openSuccess
    handles.timeSpanMinusGaps = ScoreGotoEvent(handles.SearchResultEventId); 
    ScoreGotoEvent(handles.SearchResultEventId);
else 
    warning('EEG file open failure');
end    
EnableButtonsAfterWait(handles);
handles = UpdateInfo(handles);

existingPlot = ScoreGetEeglabPlot();
if ~isempty(existingPlot)
    set(existingPlot,'ResizeFcn',@eegPlotResized_CallBack);    
end
guidata(hObject, handles);
    

function eegPlotResized_CallBack(src,evt)
thisFigure = findall(0,'Type','figure','tag','oneEventDetails');
handles = guihandles(thisFigure);
UpdateScaleInfo(handles);



function verticalScaleEdit_Callback(hObject, eventdata, handles)
% hObject    handle to verticalScaleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of verticalScaleEdit as text
%        str2double(get(hObject,'String')) returns contents of verticalScaleEdit as a double

if not(isfield(handles, 'UpdateScaleInfoTimer'))
    StartScaleTimer(handles);
end    

str=get(handles.verticalScaleEdit,'String');

if isempty(str2num(str))
    set(hObject,'string','0');
    warndlg('Input must be numerical');    
else    
    existingPlot = ScoreGetEeglabPlot();
    if not(isempty(existingPlot)) && size(existingPlot,1)==1        
        handles.verticalScaleValidForEegPlotPosition = getpixelposition(existingPlot);    
    else
        handles.verticalScaleValidForEegPlotPosition = [];
    end
    guidata(hObject, handles);
end     
handles = UpdateScaleInfo(handles);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function verticalScaleEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to verticalScaleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = UpdateScaleInfo(handles)

if not(exist('handles' ,'var')) || isempty(handles)
    thisFigure = findall(0,'Type','figure','tag','oneEventDetails');
    if not(isempty(thisFigure))    
        handles = guidata(thisFigure);
    end    
end

%if handles is empty, no figure found, means that figure has closed
if not(isempty(handles)) 
    verticalScaleEditString=get(handles.verticalScaleEdit,'String');
    if isempty(str2num(verticalScaleEditString))
        set(handles.verticalScaleEdit,'string','0');
        warndlg('Input must be numerical');
    else
        physicalSizeOfScaleMarkerInCm = str2num(verticalScaleEditString);
        existingPlot = ScoreGetEeglabPlot(0);
        if not(isempty(existingPlot)) && size(existingPlot,1)==1
            currentEegPlotPosition = getpixelposition(existingPlot);
            if isfield(handles,'verticalScaleValidForEegPlotPosition') ...
                && not(isempty(handles.verticalScaleValidForEegPlotPosition)) ...
                && all(currentEegPlotPosition == handles.verticalScaleValidForEegPlotPosition)

                ax1 = findobj('tag','eegaxis','parent',existingPlot);  % axes handle
                g = get(existingPlot,'UserData');  
                ESpacing = findobj('tag','ESpacing','parent',existingPlot);   % ui handle        
                g.spacing = str2num(get(ESpacing,'string'));  

                %Get data about the whole plot
                verticalSizeOfPlotInMicroVolts = ax1.YLim(2)-ax1.YLim(2);
                axisPosition = getpixelposition(ax1);
                verticalSizeOfPlotInPixels = axisPosition(4);        
                %sprintf('%g', verticalSizeOfPlotInPixels)

                %Get data about the SCORE scale eye                
                scoreEyeAxisVerticalScaleInMicrovolts = g.spacing*4;                
                scoreEyeAxisVerticalScaleInMicroVoltsPerCentimeter = scoreEyeAxisVerticalScaleInMicrovolts/physicalSizeOfScaleMarkerInCm;

                newText = strcat(['Vertical EEG scale: ' num2str(scoreEyeAxisVerticalScaleInMicroVoltsPerCentimeter) ' �V/cm']);
                set(handles.verticalCalculatedEegScale, 'String', newText);            
            else            
                newText = strcat(['Vertical EEG scale: unknown (plot moved or resized)']);
                set(handles.verticalCalculatedEegScale, 'String', newText);
            end
        else
            newText = strcat(['Vertical EEG scale: unknown (no plot, or >1 plot)']);
            set(handles.verticalCalculatedEegScale, 'String', newText);            
        end    
    end    
end

% --- Executes during object deletion, before destroying properties.
function oneEventDetails_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to oneEventDetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

StopScaleTimerIfExist(hObject, handles);

% --- Executes on selection change in verticalScaleMenu.
function verticalScaleMenu_Callback(hObject, eventdata, handles)
% hObject    handle to verticalScaleMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns verticalScaleMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from verticalScaleMenu

verticalScaleEdit=get(handles.verticalScaleEdit,'String');
if isempty(str2num(verticalScaleEdit)) 
    set(handles.verticalScaleMenu,'Value',1);
elseif str2num(verticalScaleEdit) == 0
    set(handles.verticalScaleMenu,'Value',1);
else
    selectedIndex = get(handles.verticalScaleMenu,'Value');
    allItems = get(handles.verticalScaleMenu,'String');
    targetVerticalPhysicalScaleInMicroVoltsPerCm = str2num(allItems(selectedIndex,:));    
        
    physicalSizeOfScaleMarkerInCm=str2num(get(handles.verticalScaleEdit,'String'));
    existingPlot = ScoreGetEeglabPlot();
    
    if not(isempty(targetVerticalPhysicalScaleInMicroVoltsPerCm)) ...
        && not(isempty(physicalSizeOfScaleMarkerInCm)) ...
        && physicalSizeOfScaleMarkerInCm>0 ...
        && not(isempty(existingPlot)) ...
        && size(existingPlot,1)==1 
                        
        g = get(existingPlot,'UserData');  
        ESpacing = findobj('tag','ESpacing','parent',existingPlot);   % ui handle        
        g.spacing = str2num(get(ESpacing,'string'));  
                
        targetScoreEyeAxisVerticalScaleInMicrovolts = targetVerticalPhysicalScaleInMicroVoltsPerCm*physicalSizeOfScaleMarkerInCm;
        
        g.spacing = targetScoreEyeAxisVerticalScaleInMicrovolts/4;
        set(ESpacing,'string',num2str(g.spacing,4))  % update edit box        
        %set(existingPlot,'UserData', g);         
        set(0, 'CurrentFigure', existingPlot)
        evalin('base', 'eegplot(''draws'',0);');
        ScoreInsertVerticalScaleEye();
        %eegplot('drawp', 0);  % redraw background
    end
end


% --- Executes during object creation, after setting all properties.
function verticalScaleMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to verticalScaleMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close oneEventDetails.
function oneEventDetails_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to oneEventDetails (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
StopScaleTimerIfExist(hObject, handles);
