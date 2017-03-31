function data = ScoreGetAnnotationsForOneEvent(searchResultEventId)    
    sql = [...
    'SELECT        SearchResult_AnnotationConfig.FieldName, SearchResult_AnnotationConfig.FieldComment, SearchResult_AnnotationConfig.HasInteger, '...
    '                         SearchResult_AnnotationConfig.HasFloat, SearchResult_AnnotationConfig.HasString, SearchResult_Event_Annotation.ValueText, '...
    '                         SearchResult_Event_Annotation.ValueInt, SearchResult_Event_Annotation.ValueFloat '...
    'FROM            SearchResult INNER JOIN '...
    '                         SearchResult_Event ON SearchResult.SearchResultId = SearchResult_Event.SearchResultId INNER JOIN '...
    '                         SearchResult_AnnotationConfig ON SearchResult.SearchResultId = SearchResult_AnnotationConfig.SearchResultId LEFT OUTER JOIN '...
    '                         SearchResult_Event_Annotation ON SearchResult_Event.SearchResultEventId = SearchResult_Event_Annotation.SearchResultEventId AND '...
    '                         SearchResult_AnnotationConfig.SearchResultAnnotationConfigId = SearchResult_Event_Annotation.SearchResultAnnotationConfigId ' ...
    'WHERE        (SearchResult_Event.SearchResultEventId = ' num2str(searchResultEventId) ');' ...
    ];
    disp(sql);
    data = ScoreQueryRun(sql);        
end
