
     
function data = ScoreSetAnnotationForOneEvent(searchResultEventId, searchResultAnnotationConfigId, fieldType, value)    

sql = ['SELECT MIN(SearchResultEventAnnotationId) FROM SearchResult_Event_Annotation ' ...
    'WHERE SearchResult_Event_Annotation.SearchResultEventId=' num2str(searchResultEventId) ...
    'AND SearchResult_Event_Annotation.SearchResultAnnotationConfigId=' num2str(searchResultAnnotationConfigId) ...
];   
existing = ScoreQueryRun(sql);

if isnan(existing.x) 
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
    elseif strcmp(fieldType, 'ValueBlob')
        sql = [sql ' ValueBlob) VALUES ('];
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
    elseif strcmp(fieldType, 'ValueBlob')
        sql = [sql num2str(value) ');'];
    end    
    data = ScoreQueryRun(sql);        
else   
    existingId = existing.x;        
    sql = 'UPDATE SearchResult_Event_Annotation SET ' ;
    if strcmp(fieldType, 'ValueText')
        sql = [sql 'ValueText=''' value ''''];
    elseif strcmp(fieldType, 'ValueInt')
        sql = [sql ' ValueInt=' num2str(value) ];
    elseif strcmp(fieldType, 'ValueFloat')
        sql = [sql ' ValueFloat=' num2str(value) ];
    elseif strcmp(fieldType, 'ValueBit')
        sql = [sql ' ValueBit=' num2str(value) ];
    elseif strcmp(fieldType, 'ValueBlob')
        sql = [sql ' ValueBlob=' num2str(value) ];
    end    
    sql = [sql ...
        ' WHERE SearchResult_Event_Annotation.SearchResultEventAnnotationId = ' ...
        num2str(existingId) ';'];
    data = ScoreQueryRun(sql);        
    
    
end        
end
