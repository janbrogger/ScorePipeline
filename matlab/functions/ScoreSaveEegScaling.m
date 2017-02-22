function ScoreSaveEEGScaling(handles)
    verticalScaleEdit =str2double(get(handles.verticalScaleEdit,'String'));
    verticalScaleValidForEegPlotPosition = [];
    targetVerticalPhysicalScaleInMicroVoltsPerCm = [];
    horisontalScaleEdit =str2double(get(handles.horisontalScaleEdit,'String'));
    horisontalScaleValidForEegPlotPosition = [];    
    targetHorisontalPhysicalScaleInMillimetersPerSecond = [];
    
    if isfield(handles, 'horisontalScaleValidForEegPlotPosition')
        horisontalScaleValidForEegPlotPosition = ...
            handles.horisontalScaleValidForEegPlotPosition;
    end
    
    if isfield(handles, 'verticalScaleValidForEegPlotPosition')
        verticalScaleValidForEegPlotPosition = ...
            handles.verticalScaleValidForEegPlotPosition;
    end
    
    if isfield(handles, 'targetVerticalPhysicalScaleInMicroVoltsPerCm')
        targetVerticalPhysicalScaleInMicroVoltsPerCm = ...
            handles.targetVerticalPhysicalScaleInMicroVoltsPerCm;
    end
    
    if isfield(handles,'targetHorisontalPhysicalScaleInMillimetersPerSecond') ...
        targetHorisontalPhysicalScaleInMillimetersPerSecond = ...
            handles.targetHorisontalPhysicalScaleInMillimetersPerSecond;
    end

    directory = [ScoreConfig.scoreBasePath '\matlab\'];
    if not(exist(directory , 'dir'))
        error( ...
        ['Fix your ScoreConfig.m file - directory not found: ' directory]);    
    end

    fileName = 'ScoreSavedEegScaling.mat';
    pathAndFileName = [directory fileName];
    
    save(pathAndFileName, ...
        'verticalScaleEdit', ...        
        'verticalScaleValidForEegPlotPosition', ...
        'targetVerticalPhysicalScaleInMicroVoltsPerCm', ...
        'horisontalScaleEdit', ...
        'horisontalScaleValidForEegPlotPosition', ...
        'targetHorisontalPhysicalScaleInMillimetersPerSecond');
        
end