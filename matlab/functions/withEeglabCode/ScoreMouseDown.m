function data = ScoreMouseDown(varargin)

    g = get(gcf,'UserData');
    cp = get(gca,'currentpoint');
    EEG = evalin('base','EEG');
    [clickedTime, clickedSample, selectedChannelIndex, clickedEegValue] = ScoreGetClickedTraceFromPoint(cp);    
    
    %disp(['Clicked elapsed time : ' num2str(clickedTime)]);  
    %disp(['Clicked sample : ' num2str(clickedSample)]);  
    %disp(['Current time position at left is ' num2str(g.time)]);
    %disp(['Current time position at right is ' num2str(g.time+g.winlength*g.srate)]);    
    %disp([' Selected channel ' EEG.chanlocs(selectedChannelIndex).labels ' ,closest EEG value ' num2str(clickedEegValue) ]);    
    
    if ~isfield(g, 'scoreAnnotationState')  || isempty(g.scoreAnnotationState)
        g.scoreAnnotationState = 'WaitingForFirstClick';        
    end
    
    if ~isempty(clickedTime)
        if strcmp(g.scoreAnnotationState, 'WaitingForFirstClick')
            g.scoreAnnotationState = 'WaitingForSecondClick';
            g.scoreClickedTime = clickedTime;
            g.scoreClickedSample = clickedSample;
            g.scoreClickedChannelIndex= selectedChannelIndex;
            g.scoreClickedEegValue = clickedEegValue;
        elseif strcmp(g.scoreAnnotationState, 'WaitingForSecondClick')
            %We have a second click, so we now have a start and stop
            g.scoreAnnotationState = 'WaitingForFirstClick';            
            clickedSamples(1) = g.scoreClickedSample;
            clickedSamples(2) = clickedSample;
            clickedChannel = g.scoreClickedChannelIndex;
            dataSegment = EEG.data(clickedChannel, clickedSamples(1):clickedSamples(2));
            [ymax ymaxsample] = max(dataSegment);
            allFigures = findall(0,'type','figure');
            oneEventDetails = findobj(allFigures, 'tag', 'oneEventDetails');
            if ~isempty(oneEventDetails)                
                handles = guidata(oneEventDetails);
                if isfield(handles, 'SearchResultEventId')                    
                    ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, 1,'',clickedSamples(1), 0);
                    ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, 2,'',clickedSamples(2), 0);                    
                    handles.UpdateCustomAnnotations(handles);
                end
            end
            
        end
    end
    
    set(gcf, 'UserData', g);
    %guidata(gcf, g);
    
end