function data = ScoreGetAnnotationsForOneProject(searchResultId)    
    data = ScoreQueryRun(['SELECT * FROM [SearchResult_AnnotationConfig] ' ... 
    ' WHERE SearchResultId=' num2str(searchResultId)]);        
end
