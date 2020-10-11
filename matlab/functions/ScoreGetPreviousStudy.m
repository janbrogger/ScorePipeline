function [searchResult_StudyId, searchResult_EventId] = ScoreGetPreviousStudy(searchResultId, currentSearchResult_StudyId)
gotPreviousStudy = 0;
failedPreviousStudy = 0;
while not(gotPreviousStudy) && not(failedPreviousStudy)
    searchResultStudyEvent = ScoreQueryRun(['SELECT MAX(SearchResultStudyId), MAX(SearchResultEventId) FROM SearchResult_Event ' ...
        'WHERE SearchResult_Event.SearchResultId = ' num2str(searchResultId) ...
        'AND SearchResult_Event.SearchResultStudyId < ' num2str(currentSearchResult_StudyId) ...
        ]);
    if not(isnan(searchResultStudyEvent{1,1}) & isnan(searchResultStudyEvent{1,2}))
        handles.SearchResultStudyId = searchResultStudyEvent{1,1};  
        handles.SearchResultEventId = searchResultStudyEvent{1,2};  
        searchResult_StudyId = handles.SearchResultStudyId;
        searchResult_EventId = handles.SearchResultEventId;
                
        handles.searchResultRecordingId = ScoreQueryRun(['SELECT MIN(SearchResultRecordingId) ' ...
        ' FROM SearchResult_Event ' ...
        ' INNER JOIN Event ON SearchResult_Event.Eventid = Event.EventId ' ...
        ' INNER JOIN Recording ON Event.RecordingId = Recording.RecordingId ' ...
        ' INNER JOIN SearchResult_Recording ON Recording.RecordingId = SearchResult_Recording.RecordingId ' ...
        ' WHERE SearchResult_Event.SearchResultEventId = ' num2str(handles.SearchResultEventId) ]);
    
        if not(isnan(handles.searchResultRecordingId{1,1}))
            handles.searchResultRecordingId = handles.searchResultRecordingId{1,1};                
        end
                
        fileExists = ScoreCheckOneRecordingFile(handles.searchResultRecordingId);
        if fileExists
            gotPreviousStudy = 1;
        else
            failedPreviousStudy = 1;
        end
    else
        failedPreviousStudy = 1;
    end
end
end