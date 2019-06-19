function projectSpecificMouseMove = GetProjectSpecificMouseMove(searchResultId)

    projectSpecificMouseMove = '';
     data = ScoreQueryRun(['SELECT MouseMoveFunction FROM [SearchResult] ' ... 
        ' WHERE SearchResultId=' num2str(searchResultId)]);

     if ~strcmp(data,'No Data')
         projectSpecificMouseMove = data.MouseMoveFunction{1,1};        
     end  
end