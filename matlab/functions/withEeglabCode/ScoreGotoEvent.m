function timeSpanMinusGaps = ScoreGotoEvent(searchResultEventId)
    disp(['Navigating to event']);    
    
    if exist('EEG', 'var')
        error('No EEG open in EEGLAB');
    end
    
    existingPlot = findobj(0, 'tag', 'EEGPLOT');
    if isempty(existingPlot)
        error('No EEG plot open in EEGLAB');
    elseif size(existingPlot,1)>1        
        warn('More than one EEGPLOT open, using the firs tone');        
        existingPlot = existingPlot(1);        
    end
    
    eventTime = ScoreQueryRun(['SELECT ' ...
        '  DATEPART(yyyy, StartDateTime) AS yy ' ...
        ' ,DATEPART(mm, StartDateTime)   AS mm ' ...
        ' ,DATEPART(dd, StartDateTime)   AS dd' ...
        ' ,DATEPART(HH, StartDateTime)   AS hh' ...
        ' ,DATEPART(mi, StartDateTime)   AS mi' ...
        ' ,DATEPART(ss, StartDateTime)   AS ss' ...
        ' ,DATEPART(ms, StartDateTime)   AS ms' ...
        ' FROM [SearchResult_Event] ' ... 
        ' INNER JOIN Event ON Event.EventId = SearchResult_Event.EventId ' ... 
        ' WHERE SearchResultEventId = ' num2str(searchResultEventId)]);
    eventTime = datetime(eventTime.yy,eventTime.mm,eventTime.dd,eventTime.hh,eventTime.mi,eventTime.ss,eventTime.ms);

    recStart = ScoreQueryRun(['SELECT ' ...
          '  DATEPART(yyyy, Recording.Start) AS yy ' ...
          ' ,DATEPART(mm, Recording.Start)   AS mm ' ...
          ' ,DATEPART(dd, Recording.Start)   AS dd' ...
          ' ,DATEPART(HH, Recording.Start)   AS hh' ...
          ' ,DATEPART(mi, Recording.Start)   AS mi' ...
          ' ,DATEPART(ss, Recording.Start)   AS ss' ...
          ' ,DATEPART(ms, Recording.Start)   AS ms' ...
          ' FROM SearchResult_Event ' ...
          ' INNER JOIN Event ON SearchResult_Event.EventId = Event.EventId ' ...
          ' INNER JOIN Recording ON Event.RecordingId= Recording.RecordingId ' ...        
          ' WHERE SearchResultEventId = ' num2str(searchResultEventId)]);
    recStart = datetime(recStart.yy,recStart.mm,recStart.dd,recStart.hh,recStart.mi,recStart.ss,recStart.ms);    

    ScoreDebugLog(['Recording start: ' datestr(recStart)]);
    ScoreDebugLog(['Event time to go to: ' datestr(eventTime)]);
    
    %ONLY FOR DEVELOPING - we fake the event time
    %eventTime = recStart + seconds(randi(1200));
    
    %The rest should be OK in production
    timeSpan = eventTime-recStart;
    ScoreDebugLog(['Timespan between recording start and event to go to: ' num2str(seconds(timeSpan))]);
    %We have now calculated the time interval in calendar time
    %but in elapsed EEG time, we need to subtract any gaps in the EEG
    
    EEG = evalin('base','EEG');
    boundaryEvents = EEG.event(strcmp('boundary', {EEG.event.type}));    
    timeSpanMinusGaps = seconds(timeSpan);
    for currentSegment = 1:size(boundaryEvents,2)
        ScoreDebugLog(['Current segment: ' num2str(currentSegment)]);
        boundaryLatency = (cell2mat({boundaryEvents(currentSegment).latency})-1)/EEG.srate;
        boundaryGap = (cell2mat({boundaryEvents(currentSegment).duration})-1)/EEG.srate;
        if timeSpanMinusGaps < boundaryLatency
            break;            
        end
        %skip this segment, and its gap
        timeSpanMinusGaps = timeSpanMinusGaps - boundaryGap;
    end
    
    
    EPosition = findobj('tag','EPosition','parent',existingPlot); % ui handle
    set(EPosition, 'string', num2str(timeSpanMinusGaps));
               
    %evalin('base','eegplot(''drawp'', 0);');    
    eegplot('drawp', 0, '', existingPlot);
    ScoreDebugLog(['Timespan between recording start and event to go to, when accounting for gaps: ' num2str(timeSpanMinusGaps) ' seconds']);
    ScoreDebugLog(['Timespan between recording start and event to go to, when accounting for gaps: ' num2str(timeSpanMinusGaps*EEG.srate) ' samples'] );
    
    %latencies = [EEG.event(:).latency] / EEG.srate
    %fprintf('%5.1f \r\n', latencies)
    %[EEG.event(:).seconds] = [EEG.event(:).latency]' / EEG.srate;
    %[EEG.event(:).latency2] = deal(1) 
    %[EEG.event(:).latency2] = [[EEG.event(:).latency ] / EEG.srate]
    %struct2table(EEG.event)
end
