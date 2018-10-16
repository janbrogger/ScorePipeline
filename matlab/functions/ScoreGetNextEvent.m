function [searchResult_EventId] = ScoreGetNextEvent(searchResultId, currentSearchResult_EventId)
gotNextEvent = 0;
failedNextEvent = 0;

while not(gotNextEvent) && not(failedNextEvent)
    searchResultEventId = ScoreQueryRun(['SELECT MIN(SearchResultEventId) FROM SearchResult_Event ' ...
        'WHERE SearchResult_Event.SearchResultId = ' num2str(searchResultId) ...
        'AND SearchResult_Event.SearchResultEventId > ' num2str(currentSearchResult_EventId) ...
        ]);
    if not(isnan(searchResultEventId{1}))
        handles.SearchResultEventId = searchResultEventId{1};                
                
        handles.searchResultRecordingId = ScoreQueryRun(['SELECT MIN(SearchResultRecordingId) ' ...
        ' FROM SearchResult_Event ' ...
        ' INNER JOIN Event ON SearchResult_Event.Eventid = Event.EventId ' ...
        ' INNER JOIN Recording ON Event.RecordingId = Recording.RecordingId ' ...
        ' INNER JOIN SearchResult_Recording ON Recording.RecordingId = SearchResult_Recording.RecordingId ' ...
        ' WHERE SearchResult_Event.SearchResultEventId = ' num2str(handles.SearchResultEventId) ]);
    
        if not(isnan(handles.searchResultRecordingId{1}))
            handles.searchResultRecordingId = handles.searchResultRecordingId{1};                
        end
                
        fileExists = ScoreCheckOneRecordingFile(handles.searchResultRecordingId);
        if fileExists
            gotNextEvent = 1;
        else
            failedNextEvent = 1;
        end
    else
        failedNextEvent = 1;
    end
end
end