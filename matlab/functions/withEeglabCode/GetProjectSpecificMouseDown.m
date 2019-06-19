function projectSpecificMouseDown = GetProjectSpecificMouseDown(searchResultId)

    projectSpecificMouseDown = '';
     data = ScoreQueryRun(['SELECT MouseDownFunction FROM [SearchResult] ' ... 
        ' WHERE SearchResultId=' num2str(searchResultId)]);

     if ~strcmp(data,'No Data')
         projectSpecificMouseDown = data.MouseDownFunction{1,1};        
     end  
end