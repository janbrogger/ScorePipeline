function data = ScoreCreateAnnotationConfig(searchResultId, level, fieldName, fieldComment, hasInteger, hasFloat, hasString, hasBit, hasBlob)
    
    sql= ...
        ['INSERT INTO [SearchResult_AnnotationConfig] ' ...
        ' (SearchResultId, AnnotationLevel, FieldName, FieldComment, HasInteger, HasFloat, HasString, HasBit, HasBlob) ' ...
        ' VALUES (' ...
        num2str(searchResultId) ', ' ...
        '''' level ''', ' ...
        '''' fieldName ''', ' ...
        '''' fieldComment ''', ' ...
        num2str(hasInteger) ', ' ...
        num2str(hasFloat)  ', ' ...
        num2str(hasString) ', '  ...
        num2str(hasBit)  ', ' ...
        num2str(hasBlob)  ...
        ')'];
    
    data = ScoreQueryRun(sql);
    
end