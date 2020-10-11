     
function searchresulteventmultiPK = ScoreAddEventMulti(searchResultId, searchResultEventId)    

sql = ScoreQueryRun(['INSERT INTO SearchResult_Event_Multi (SearchResultId, WorkflowState, FileState, SearchResultEventId) VALUES (' num2str(searchResultId) ', 0, 0, ' num2str(searchResultEventId) ')']);
sqlPK = ScoreQueryRun(['SELECT MAX(SearchResultEventMultiId) FROM SearchResult_Event_Multi']);
searchresulteventmultiPK = sqlPK.x(1);

end
