function isNamingBlindedSearchResult = IsNamingBlindedSearchResult(searchResultId)    
    isNamingBlindedSearchResult = false;
     data = ScoreQueryRun(['SELECT IsNamingBlinded FROM [SearchResult] ' ... 
        ' WHERE SearchResultId=' num2str(searchResultId)]);

     if ~strcmp(data,'No Data')
        if data.IsNamingBlinded
            isNamingBlindedSearchResult = true;           
        end
     end                         
end