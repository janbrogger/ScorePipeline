function pdf = ScoreOpenReportForSearchResultEvent(searchResultEventId)

    reportQuery = ['SELECT Description.DescriptionId, Description.Pdf ' ...
        'FROM  SearchResult_Event  ' ...
        'INNER JOIN Event ON SearchResult_Event.EventId = Event.EventId ' ...
        'INNER JOIN EventCoding ON Event.EventCodingId = EventCoding.EventCodingId ' ...
        'INNER JOIN Description ON EventCoding.DescriptionId = Description.DescriptionId ' ...
        'WHERE SearchResult_Event.SearchResultEventId = ' num2str(searchResultEventId)  ...        
         ];
    data = ScoreQueryRun(reportQuery);
    
    %disp(data);
    if ~strcmp(data, 'No Data')          
        pdf = cell2mat(data.Pdf);
        if size(pdf,1) > 4
            pdf = typecast(pdf,'uint8');
            tempFileName = tempname;
            [pathstr, name, ext] = fileparts(tempFileName);
            tempFileName = [pathstr name '.pdf'];
            %disp(tempFileName);
            fileID = fopen(tempFileName,'w');
            if fileID ~= -1            
                fwrite(fileID,pdf);
                fclose(fileID);
                winopen(tempFileName);
            else
                warning(['Could not open file ' tempFileName]);
            end
        else
            warning('Report not stored in database');
        end
    else
        warning('No report found (no description in database?)');
    end
end