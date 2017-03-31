
     
function data = ScoreSetAnnotationForOneEvent(searchResultEventId, SearchResultAnnotationConfigId, valueText, valueInt, valueFloat)    
sql = [...
' INSERT INTO SearchResult_Event_Annotation (SearchResultEventId, SearchResultAnnotationConfigId, ValueText, ValueInt, ValueFloat) ' ...
'VALUES (' num2str(searchResultEventId) ', ' num2str(SearchResultAnnotationConfigId) ...
', ''' valueText ''',' num2str(valueInt) ', ' num2str(valueFloat) ');']; 

disp(sql);
    data = ScoreQueryRun(sql);        
end
