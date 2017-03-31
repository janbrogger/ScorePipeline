function varargout = ScoreSelectUser(varargin)
% SCORESELECTUSER MATLAB code for ScoreSelectUser.fig
%      SCORESELECTUSER, by itself, creates a new SCORESELECTUSER or raises the existing
%      singleton*.
%
%      H = SCORESELECTUSER returns the handle to a new SCORESELECTUSER or the handle to
%      the existing singleton*.
%
%      SCORESELECTUSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCORESELECTUSER.M with the given input arguments.
%
%      SCORESELECTUSER('Property','Value',...) creates a new SCORESELECTUSER or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ScoreSelectUser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ScoreSelectUser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ScoreSelectUser

% Last Modified by GUIDE v2.5 31-Mar-2017 15:11:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScoreSelectUser_OpeningFcn, ...
                   'gui_OutputFcn',  @ScoreSelectUser_OutputFcn, ...
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

% --- Executes just before ScoreSelectUser is made visible.
function ScoreSelectUser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScoreSelectUser (see VARARGIN)

% Choose default command line output for ScoreSelectUser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes ScoreSelectUser wait for user response (see UIRESUME)
% uiwait(handles.scoreSelectUser);


% --- Outputs from this function are returned to the command line.
function varargout = ScoreSelectUser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

userListSql = [...
'SELECT DISTINCT       [User].UserName ' ...
'FROM            [User] INNER JOIN ' ...
'                         User_Role ON [User].UserId = User_Role.UserId INNER JOIN ' ...
'                         Role ON User_Role.RoleId = Role.RoleId ' ...
'WHERE Role.Name = ''Physician'' OR Role.Name = ''Administrator'' ' ...    
    ];
userList = ScoreQueryRun(userListSql); 
username=getenv('USERNAME');
defaultSelection = 1;
foundCurrentUser = find(contains(userList.UserName,username));
if ~isempty(foundCurrentUser)
    defaultSelection = foundCurrentUser;
end    
set(handles.userList,'String',userList.UserName, 'Value', defaultSelection);


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)


% Update handles structure
guidata(handles.scoreSelectUser, handles);


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

userList = get(handles.userList,'String');
selectedUserIndex = get(handles.userList,'Value');
currentUser = char(userList(selectedUserIndex));
assignin('base', 'scoreUser', currentUser);
close(gcf) ;


% --- Executes on selection change in userList.
function userList_Callback(hObject, eventdata, handles)
% hObject    handle to userList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns userList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from userList


% --- Executes during object creation, after setting all properties.
function userList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to userList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
