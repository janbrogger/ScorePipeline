function data = ScoreDeleteAnnotationConfig(searchResultAnnotationConfigId)
    
    sql = [
        'DELETE FROM [SearchResult_AnnotationConfig] ' ...        
        'WHERE SearchResultAnnotationConfigId=' ...
        num2str(searchResultAnnotationConfigId)];
    data = ScoreQueryRun(sql);
end