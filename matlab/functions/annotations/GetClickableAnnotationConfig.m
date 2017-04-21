function [searchResultAnnotationConfigIdSampleStart, searchResultAnnotationConfigIdSampleEnd] = GetClickableAnnotationConfig(searchResultId)
    searchResultAnnotationConfigIdSampleStart = [];
    searchResultAnnotationConfigIdSampleEnd = [];
    configData = ScoreGetAnnotationsForOneProject(searchResultId);
    if ~strcmp(configData,'No Data')
        for i=1:size(configData,1)
            if strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'SpikeStartSample')
                searchResultAnnotationConfigIdSampleStart = configData.SearchResultAnnotationConfigId(i);
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'SpikeEndSample')
                searchResultAnnotationConfigIdSampleEnd = configData.SearchResultAnnotationConfigId(i);                
            end
        end
    end                     
end