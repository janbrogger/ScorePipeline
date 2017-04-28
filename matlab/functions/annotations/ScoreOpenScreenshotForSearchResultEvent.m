function png = ScoreOpenScreenshotForSearchResultEvent(searchResultEventId)

    screenshotQuery = ['SELECT SearchResult_Event_Annotation.ValueBlob ' ...
        'FROM  SearchResult_Event_Annotation  ' ...
        'INNER JOIN SearchResult_AnnotationConfig ON SearchResult_Event_Annotation.SearchResultAnnotationConfigId = SearchResult_AnnotationConfig.SearchResultAnnotationConfigId ' ...        
        'WHERE SearchResult_AnnotationConfig.FieldName=N''Screenshot'' ' ...
        'AND SearchResult_AnnotationConfig.HasBlob=1 ' ...
        'AND SearchResult_Event_Annotation.SearchResultEventId = ' num2str(searchResultEventId)  ...        
         ];
    data = ScoreQueryRun(screenshotQuery);
    
    %disp(data);
    if ~strcmp(data, 'No Data')          
        png = System.Convert.FromBase64String(cell2mat(data.ValueBlob));  
        png = uint8(png);
        if size(png,2) > 1            
            tempFileName = tempname;
            [pathstr, name, ext] = fileparts(tempFileName);
            tempFileName = [pathstr name '.png'];
            %disp(tempFileName);
            fileID = fopen(tempFileName,'w');
            if fileID ~= -1            
                fwrite(fileID,png);
                fclose(fileID);
                winopen(tempFileName);
            else
                warning(['Could not open file ' tempFileName]);
            end
        else
            warning('Screenshot not found');
        end
    else
        warning('Screenshot not found');
    end
end