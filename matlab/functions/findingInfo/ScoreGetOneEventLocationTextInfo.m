function text = ScoreGetOneEventLocationTextInfo(searchResultEventId, useHTMLBreak)

    shoppingBasketQuery = ['SELECT DISTINCT SearchResult_Event.SearchResultEventId, ' ...
        'LocationType.Lang_eng AS LocationTypeName, ' ...
        'Sensor.Name AS SensorName, ' ...
        'SensorSelectionType.Description AS SensorSelectionType ' ...
        'FROM   SearchResult_Event ' ...
        'INNER JOIN Event ON SearchResult_Event.EventId = Event.EventId ' ...
        'INNER JOIN EventCoding ON Event.EventCodingId = EventCoding.EventCodingId  ' ...
        'INNER JOIN Event AS Event2 ON EventCoding.EventCodingId = Event2.EventCodingId  ' ...        
        'INNER JOIN LocationCoding ON Event2.EventId = LocationCoding.EventId  ' ...
        'INNER JOIN LocationSensorCoding ON LocationCoding.LocationCodingId = LocationSensorCoding.LocationCodingId ' ...
        'INNER JOIN LocationType ON LocationSensorCoding.LocationTypeId = LocationType.LocationTypeId  ' ...
        'INNER JOIN Sensor ON LocationSensorCoding.SensorId = Sensor.SensorId ' ...
        'INNER JOIN SensorSelectionType ON LocationSensorCoding.SensorSelectionTypeId = SensorSelectionType.SensorSelectionTypeId ' ...        
         ];
     shoppingBasketQuery = [shoppingBasketQuery ...         
        'WHERE SearchResult_Event.SearchResultEventId=' num2str(searchResultEventId) ' ORDER BY LocationTypeName, SensorSelectionType ' ];
    data = ScoreQueryRun(shoppingBasketQuery);
    
    %disp(data);
    text = '';
    isMultipleEventPerEEG = getappdata(0, 'isMultipleEventPerEEG');
    
    if (~strcmp(data, 'No Data') && isMultipleEventPerEEG ~= 1)    
        indeterminate = '';
        indeterminateCount = 0;
        selected = '';
        selectedCount = 0;
        hasNonOnsetData = 0;
        for i=1:numel(data.SensorName)            
            if ~strcmp(data.LocationTypeName(i), 'Localisation - onset')
                hasNonOnsetData = 1;                
            elseif strcmp(data.SensorSelectionType(i), 'Indeterminate')
                indeterminate = [indeterminate ' ' data.SensorName(i)];
                indeterminateCount = indeterminateCount+1;
            elseif strcmp(data.SensorSelectionType(i), 'Selected')        
                selected = [selected ' ' data.SensorName(i)];
                selectedCount = selectedCount +1;
            end                        
        end
        text = [text 'Selected ('  num2str(selectedCount) '): ' selected ...
                     '. Indeterminate (' num2str(indeterminateCount) '): ' indeterminate];        
        if hasNonOnsetData == 1
            text = [text ' (Also has non-onset data)'];
        end
        text = strjoin(text);
    else
        text = 'No location info';
    end
end