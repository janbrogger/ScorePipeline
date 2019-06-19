function projectSpecificMouseUp = GetProjectSpecificMouseUp(searchResultId)

    projectSpecificMouseUp = '';
     data = ScoreQueryRun(['SELECT MouseUpFunction FROM [SearchResult] ' ... 
        ' WHERE SearchResultId=' num2str(searchResultId)]);

     if ~strcmp(data,'No Data')
         projectSpecificMouseUp = data.MouseUpFunction{1,1};        
     end  
end