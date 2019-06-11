function [Start, Center,End, SlowEnd, ClickedChannel] = GetClickableAnnotationConfig(searchResultId)
    Start = [];
    Center = [];
    End = [];
    SlowEnd = [];
    ClickedChannel = [];
    configData = ScoreGetAnnotationsForOneProject(searchResultId);
    if ~strcmp(configData,'No Data')
        for i=1:size(configData,1)
            if strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'Start')
                Start = configData.SearchResultAnnotationConfigId(i);
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'Center')
                Center = configData.SearchResultAnnotationConfigId(i);  
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'End')
                End = configData.SearchResultAnnotationConfigId(i); 
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'SlowEnd')
                SlowEnd = configData.SearchResultAnnotationConfigId(i); 
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'ClickedChannel')
                ClickedChannel = configData.SearchResultAnnotationConfigId(i);    
            end
        end
    end                     
end