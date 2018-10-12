function [spikeStart, spikeCenter,spikeEnd, afterDischargeEnd, spikeclickedChannel] = GetClickableAnnotationConfigForSTATAFocalEpi(searchResultId)
    spikeStart = [];
    spikeCenter = [];
    spikeEnd = [];
    afterDischargeEnd = [];
    spikeclickedChannel = [];
    configData = ScoreGetAnnotationsForOneProject(searchResultId);
    if ~strcmp(configData,'No Data')
        for i=1:size(configData,1)
            if strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'SpikeStart')
                spikeStart = configData.SearchResultAnnotationConfigId(i);
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'SpikeCenter')
                spikeCenter = configData.SearchResultAnnotationConfigId(i);  
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'SpikeEnd')
                spikeEnd = configData.SearchResultAnnotationConfigId(i); 
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'AfterDischargeEnd')
                afterDischargeEnd = configData.SearchResultAnnotationConfigId(i); 
            elseif strcmp(configData.AnnotationLevel(i), 'Event') ...
                && strcmp(configData.FieldName(i), 'SpikeClickedChannel')
                spikeclickedChannel = configData.SearchResultAnnotationConfigId(i);    
            end
        end
    end                     
end