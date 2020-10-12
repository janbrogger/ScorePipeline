     
function searchresultfakeeventPK = ScoreAddFakeEvent(searchResultId, searchResultStudyId)    

sql = ScoreQueryRun(['INSERT INTO SearchResult_FakeEvent (SearchResultId, WorkflowState, FileState, SearchResultStudyId) VALUES (' num2str(searchResultId) ', 0, 0, ' num2str(searchResultStudyId) ')']);
sqlPK = ScoreQueryRun(['SELECT MAX(SearchResultFakeEventId) FROM SearchResult_FakeEvent']);
searchresultfakeeventPK = sqlPK.x(1);

end
