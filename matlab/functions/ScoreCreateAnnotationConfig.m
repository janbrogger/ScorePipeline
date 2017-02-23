function data = ScoreCreateAnnotationConfig(searchResultId, fieldName, fieldComment, hasInteger, hasFloat, hasString)
    
    sql= ...
        ['INSERT INTO [SearchResult_AnnotationConfig] ' ...
        ' (SearchResultId, AnnotationLevel, FieldName, FieldComment, HasInteger, HasFloat, HasString) ' ...
        ' VALUES (' ...
        num2str(searchResultId) ', ' ...
        '''Event'', ' ...
        '''' fieldName ''', ' ...
        '''' fieldComment ''', ' ...
        num2str(hasInteger) ', ' ...
        num2str(hasFloat) ', ' ...
        num2str(hasString)  ...
        ')'];
    
    data = ScoreQueryRun(sql);
    
end