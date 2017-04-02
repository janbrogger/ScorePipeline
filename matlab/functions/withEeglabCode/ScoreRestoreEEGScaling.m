function ScoreRestoreEEGScaling(hObject, handles, printWarning)
    directory = [ScoreConfig.scoreBasePath '\matlab\'];
    if not(exist(directory , 'dir'))
        error( ...
        ['Fix your ScoreConfig.m file - directory not found: ' directory]);    
    end
    
    if not(exist('printWarning','var'))
        printWarning = true;
    end

    fileName = 'ScoreSavedEegScaling.mat';
    pathAndFileName = [directory fileName];
    
    
    
    verticalScaleEdit = [];
    verticalScaleValidForEegPlotPosition = [];
    targetVerticalPhysicalScaleInMicroVoltsPerCm = [];
    horisontalScaleEdit = [];
    horisontalScaleValidForEegPlotPosition = [];
    targetHorisontalPhysicalScaleInMillimetersPerSecond = [];
    
    if not(exist(pathAndFileName , 'file'))
        if printWarning
            warning('Cannot restore EEG scaling - no file found');            
        end        
    else
        load(pathAndFileName);                    
    end
    
    handles.verticalScaleValidForEegPlotPosition = ...
            verticalScaleValidForEegPlotPosition;
    handles.targetVerticalPhysicalScaleInMicroVoltsPerCm = ...
        targetVerticalPhysicalScaleInMicroVoltsPerCm;

    handles.horisontalScaleValidForEegPlotPosition = ...
        horisontalScaleValidForEegPlotPosition;
    handles.targetHorisontalPhysicalScaleInMillimetersPerSecond = ...
        targetHorisontalPhysicalScaleInMillimetersPerSecond;
    
    
    guidata(hObject, handles);
    
    %restore two textboxes
    if isfield(handles, 'verticalScaleEdit')
        set(handles.verticalScaleEdit, 'String', verticalScaleEdit);
    else
        warning('Vertical scale edit textbox not found')
    end
    
    if isfield(handles, 'horisontalScaleEdit')
        set(handles.horisontalScaleEdit, 'String', horisontalScaleEdit);
    else
        warning('Horisontal scale edit textbox not found')        
    end
    
    %restore horisontal scale menu selection if matching item is found
    if not(isempty(handles.targetHorisontalPhysicalScaleInMillimetersPerSecond)) 
        allHorisontalScaleMenuItems = get(handles.horisontalScaleMenu,'String');                    
        selectedHorisontalScaleMenuIndex = get(handles.horisontalScaleMenu,'Value');
        for i=1:size(allHorisontalScaleMenuItems)
            thisHorisontalScaleMenuItem = str2double(allHorisontalScaleMenuItems(i,:));
            if not(isempty(thisHorisontalScaleMenuItem)) ...
                && thisHorisontalScaleMenuItem == handles.targetHorisontalPhysicalScaleInMillimetersPerSecond...
                && i ~= selectedHorisontalScaleMenuIndex
                set(handles.horisontalScaleMenu,'Value',i);
                break;
            end
        end
    end
    
    %restore vertical scale menu selection if matching item is found
    if not(isempty(handles.targetVerticalPhysicalScaleInMicroVoltsPerCm)) 
        allVerticalScaleMenuItems = get(handles.verticalScaleMenu,'String');                    
        selectedVerticalScaleMenuIndex = get(handles.verticalScaleMenu,'Value');
        for i=1:size(allVerticalScaleMenuItems)
            thisVerticalScaleMenuItem = str2double(allVerticalScaleMenuItems(i,:));
            if not(isempty(thisVerticalScaleMenuItem)) ...
                && thisVerticalScaleMenuItem == handles.targetVerticalPhysicalScaleInMicroVoltsPerCm ...
                && i ~= selectedVerticalScaleMenuIndex
                set(handles.verticalScaleMenu,'Value',i);
                break;
            end
        end
    end  
end