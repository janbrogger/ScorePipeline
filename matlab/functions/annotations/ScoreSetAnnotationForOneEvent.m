
     
function data = ScoreSetAnnotationForOneEvent(searchResultEventId, searchResultAnnotationConfigId, fieldType, value)    

sql = ['SELECT MIN(SearchResultEventAnnotationId) FROM SearchResult_Event_Annotation ' ...
    'WHERE SearchResult_Event_Annotation.SearchResultEventId=' num2str(searchResultEventId) ...
    'AND SearchResult_Event_Annotation.SearchResultAnnotationConfigId=' num2str(searchResultAnnotationConfigId) ...
];   
existing = ScoreQueryRun(sql);

if isnan(existing.x) 
    if strcmp(fieldType, 'ValueBlob')
        conn = ScoreDbConnGet();
        colnames = {'SearchResultEventId','SearchResultAnnotationConfigId','ValueBlob'};
        base64blob = base64encode(value);
        insertdata = {searchResultEventId,searchResultAnnotationConfigId, base64blob};
        %insertdata = cell2table(insertdata,'VariableNames',colnames);        
        fastinsert(conn,'SearchResult_Event_Annotation',colnames,insertdata)        
    else
        sql = ['INSERT INTO SearchResult_Event_Annotation ' ...
            '(SearchResultEventId, SearchResultAnnotationConfigId, '];        
        if strcmp(fieldType, 'ValueText')
            sql = [sql 'ValueText) VALUES ('];
        elseif strcmp(fieldType, 'ValueInt')
            sql = [sql ' ValueInt) VALUES ('];
        elseif strcmp(fieldType, 'ValueFloat')
            sql = [sql ' ValueFloat) VALUES ('];
        elseif strcmp(fieldType, 'ValueBit')
            sql = [sql ' ValueBit) VALUES ('];        
        end    
        sql = [sql num2str(searchResultEventId) ', '];
        sql = [sql num2str(searchResultAnnotationConfigId) ', '];    
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
else   
    existingId = existing.x; 
    if strcmp(fieldType, 'ValueBlob')
        %Updating a BLOB doesn't work. 
        %MATLAB doesn't support varbinary(max)
        %Hence, we have to delete, then insert the value
        ScoreQueryRun(['DELETE FROM SearchResult_Event_Annotation ' ...
            ' WHERE [SearchResultEventAnnotationId]= ' ...
            num2str(existingId)]);
        conn = ScoreDbConnGet();
        colnames = {'SearchResultEventId','SearchResultAnnotationConfigId','ValueBlob'};
        base64blob = base64encode(value);
        insertdata = {searchResultEventId,searchResultAnnotationConfigId, base64blob};        
        %insertdata = cell2table(insertdata,'VariableNames',colnames);
        fastinsert(conn,'SearchResult_Event_Annotation',colnames,insertdata)        
    else               
        sql = 'UPDATE SearchResult_Event_Annotation SET ' ;
        if strcmp(fieldType, 'ValueText')
            sql = [sql 'ValueText=''' value ''''];
        elseif strcmp(fieldType, 'ValueInt')
            sql = [sql ' ValueInt=' num2str(value) ];
        elseif strcmp(fieldType, 'ValueFloat')
            sql = [sql ' ValueFloat=' num2str(value) ];
        elseif strcmp(fieldType, 'ValueBit')
            sql = [sql ' ValueBit=' num2str(value) ];        
        end
        sql = [sql ...
            ' WHERE SearchResult_Event_Annotation.SearchResultEventAnnotationId = ' ...
            num2str(existingId) ';'];
        data = ScoreQueryRun(sql);        
    end          
end
