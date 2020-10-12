
     
function data = ScoreSetAnnotationForFakeEvent(searchResultFakeEventId,searchResultAnnotationConfigId, fieldType, value)    

[scoreUserId, scoreUserName] = ScoreGetCurrentUser(1);

if strcmp(fieldType, 'ValueBlob')
    conn = ScoreDbConnGet();
    colnames = {'SearchResultFakeEventId', 'SearchResultAnnotationConfigId','UserId','ValueBlob'};
    base64blob = base64encode(value);
    insertdata = {searchResultFakeEventId, searchResultAnnotationConfigId, scoreUserId, base64blob};
    %insertdata = cell2table(insertdata,'VariableNames',colnames);        
    fastinsert(conn,'SearchResult_FakeEvent_Annotation',colnames,insertdata)        
else
    sql = ['INSERT INTO SearchResult_FakeEvent_Annotation ' ...
        '(SearchResultFakeEventId, SearchResultAnnotationConfigId, UserId, '];        
    if strcmp(fieldType, 'ValueText')
        sql = [sql 'ValueText) VALUES ('];
    elseif strcmp(fieldType, 'ValueInt')
        sql = [sql ' ValueInt) VALUES ('];
    elseif strcmp(fieldType, 'ValueFloat')
        sql = [sql ' ValueFloat) VALUES ('];
    elseif strcmp(fieldType, 'ValueBit')
        sql = [sql ' ValueBit) VALUES ('];        
    end    
    sql = [sql num2str(searchResultFakeEventId) ', '];
    sql = [sql num2str(searchResultAnnotationConfigId) ', '];    
    sql = [sql num2str(scoreUserId) ', '];    
    if strcmp(fieldType, 'ValueText')
        sql = [sql '''' value ''');'];
    elseif strcmp(fieldType, 'ValueInt')
        sql = [sql num2str(value) ');'];
    elseif strcmp(fieldType, 'ValueFloat')
        sql = [sql num2str(value) ');'];
    elseif strcmp(fieldType, 'ValueBit')
        sql = [sql num2str(value) ');'];        
    end    
    data = ScoreQueryRun(sql);        
end    
       
end
