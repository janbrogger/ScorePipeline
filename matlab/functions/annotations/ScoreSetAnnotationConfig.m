function data = ScoreSetAnnotationConfig(searchResultAnnotationConfigId, fieldName, fieldComment, hasInteger, hasFloat, hasString, hasBit)
    
    sql = [
        'UPDATE [SearchResult_AnnotationConfig] ' ...
        'SET FieldName='''  fieldName ''', ' ...
        'FieldComment='''  fieldComment ''', ' ...
        'HasInteger=' num2str(hasInteger) ', ' ...
        'HasFloat=' num2str(hasFloat) ', ' ...
        'HasString=' num2str(hasString) ', ' ...
        'HasBit=' num2str(hasBit) ' ' ...
        'WHERE SearchResultAnnotationConfigId=' ...
        num2str(searchResultAnnotationConfigId)];
    sql = strjoin(sql,'');
    data = ScoreQueryRun(sql);
end