function [timeSpanMinusGaps, recStart, eventTime] = ScoreGotoEvent(searchResultEventId)
    disp(['Navigating to event']);    
    
    if exist('EEG', 'var')
        error('No EEG open in EEGLAB');
    end
    
    existingPlot = ScoreGetEeglabPlot();
    if isempty(existingPlot)
        disp('EEG plot not found, cannot goto event');
    else
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

        EEG = evalin('base','EEG');
        recStart = EEG.startDateTime;   

        ScoreDebugLog(['Recording start: ' datestr(recStart)]);
        ScoreDebugLog(['Event time to go to: ' datestr(eventTime)]);
        
        timeSpan = eventTime-recStart;
        ScoreDebugLog(['Timespan between recording start and event to go to, before gaps: ' num2str(seconds(timeSpan))]);
        %We have now calculated the time interval in calendar time
        %but in elapsed EEG time, we need to subtract any gaps in the EEG

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

        %Add a little buffer on the left side
        if timeSpanMinusGaps > 1
            timeSpanMinusGaps = timeSpanMinusGaps -1;
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
end
