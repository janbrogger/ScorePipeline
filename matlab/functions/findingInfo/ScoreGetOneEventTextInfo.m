function text = ScoreGetOneEventTextInfo(searchResultId, searchResultEventId, useHTMLBreak)    

    %Get all the event property codings for all the events that this
    %event is coupled to via EventPropertyCoding
    shoppingBasketQuery = [...
    'SELECT q.EventId1, q.EventCodingId, EventCode.LongDescription_eng AS EventCodeName, Event.EventId, EventPropertyCode.Description AS EventPropertyCodeName, EventPropertyType.Lang_eng AS EventPropertyTypeName FROM ( ' ...
	'SELECT        SearchResult_Event.SearchResultEventId, Event.EventId AS EventId1, EventCoding.EventCodingId, EventCoding.EventCodeId ' ...
	'FROM            SearchResult_Event INNER JOIN ' ...
	'						 Event ON SearchResult_Event.EventId = Event.EventId INNER JOIN ' ...
	'						 EventCoding ON Event.EventCodingId = EventCoding.EventCodingId  ' ...
	'WHERE SearchResult_Event.SearchResultEventId = ' num2str(searchResultEventId) ' ) q  ' ...
	'INNER JOIN Event ON Event.EventCodingId = q.EventCodingId  ' ...
	'INNER JOIN EventPropertyCoding ON Event.EventId = EventPropertyCoding.EventId  ' ...
	'INNER JOIN EventPropertyCode ON EventPropertyCoding.EventPropertyCodeId = EventPropertyCode.EventPropertyCodeId ' ...
    'INNER JOIN EventPropertyType ON EventPropertyCode.EventPropertyTypeId = EventPropertyType.EventPropertyTypeId ' ...
	'INNER JOIN EventCode ON q.EventCodeId = EventCode.EventCodeId ' ...
    'WHERE NOT EventPropertyCode.Description = ''Undetermined'' ' ... 
         ];
    data = ScoreQueryRun(shoppingBasketQuery);
    
    %disp(data);
    text = '';
    if ~strcmp(data, 'No Data')
        if (~IsNamingBlindedSearchResult(searchResultId))
            text = [ data.EventCodeName(1) ];
        end
        for i=1:numel(data.EventPropertyTypeName)            
            if (~IsNamingBlindedSearchResult(searchResultId))                
                if useHTMLBreak
                    text = [text '<BR>'];
                end
                text = [text data.EventPropertyTypeName(i) ':' data.EventPropertyCodeName(i)];  
            end            
        end
        if ~isempty(text)
            text = strjoin(text);
        end
    else        
        %No event properties listed, get only the event code name
        shoppingBasketQuery = ['SELECT  ' ... 
        'SearchResult_Event.SearchResultEventId, ' ...
        'EventCode.Name AS EventCodeName, ' ...
        'EventCode.Code AS EventCodeCode ' ...        
        'FROM   SearchResult_Event  INNER JOIN ' ...
        'Event ON SearchResult_Event.EventId = Event.EventId INNER JOIN ' ...
        'EventCoding ON Event.EventCodingId = EventCoding.EventCodingId INNER JOIN ' ...
        'EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId   ' ...          
         ];
        data = ScoreQueryRun([shoppingBasketQuery ...             
            'WHERE SearchResult_Event.SearchResultEventId=' num2str(searchResultEventId) ]);
        text = [ data.EventCodeName(1) ];
        text = strjoin(text);
    end
end