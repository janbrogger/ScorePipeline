function ScoreGotoEvent(searchResultEventId)
    disp(['Navigating to event']);    
    
    if exist('EEG', 'var')
        error('No EEG open in EEGLAB');
    end
    
    existingPlot = findobj(0, 'tag', 'EEGPLOT');
    if isempty(existingPlot)
        error('No EEG plot open in EEGLAB');
    end
    
    eventTime = ScoreQueryRun(['SELECT StartDateTime FROM [SearchResult_Event] ' ... 
        ' INNER JOIN Event ON Event.EventId = SearchResult_Event.EventId ' ... 
        ' WHERE SearchResultEventId = ' num2str(searchResultEventId)]);
    eventTime = eventTime.StartDateTime;

    recStart = ScoreQueryRun(['SELECT Recording.Start ' ...
              ' FROM SearchResult_Event ' ...
              ' INNER JOIN Event ON SearchResult_Event.EventId = Event.EventId ' ...
              ' INNER JOIN Recording ON Event.RecordingId= Recording.RecordingId ' ...        
              ' WHERE SearchResultEventId = ' num2str(searchResultEventId)]);
    recStart = recStart.Start;

    ScoreDebugLog(['Recording start: ' datestr(recStart)]);
    ScoreDebugLog(['Event time to go to: ' datestr(eventTime)]);
    %timeSpan = eventTime-recStart;
    %ScoreDebugLog(['Timespan between recording start and event to go to: ' num2str(timeSpan)]);
          
end
