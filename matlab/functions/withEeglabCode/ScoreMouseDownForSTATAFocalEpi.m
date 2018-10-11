function data = ScoreMouseDownForSTATAFocalEpi(varargin)

    g = get(gcf,'UserData');
    cp = get(gca,'currentpoint');
    EEG = evalin('base','EEG');
    [clickedTime, clickedSample, selectedChannelIndex, clickedEegValue] = ScoreGetClickedTraceFromPoint(cp);    
    
    %disp(['Clicked elapsed time : ' num2str(clickedTime)]);  
    %disp(['Clicked sample : ' num2str(clickedSample)]);  
    %disp(['Current time position at left is ' num2str(g.time)]);
    %disp(['Current time position at right is ' num2str(g.time+g.winlength*g.srate)]);    
    %disp([' Selected channel ' EEG.chanlocs(selectedChannelIndex).labels ' ,closest EEG value ' num2str(clickedEegValue) ]);    
    
    if ~isfield(g, 'scoreAnnotationState')  || isempty(g.scoreAnnotationState)
        g.scoreAnnotationState = 'WaitingForFirstClick';        
    end
    
    if ~isempty(clickedTime)
        if strcmp(g.scoreAnnotationState, 'WaitingForFirstClick')
            g.scoreAnnotationState = 'WaitingForClick2';
            g.scoreClickedSample = [];
            g.scoreClickedTime = clickedTime;
            g.scoreClickedSample = [g.scoreClickedSample clickedSample];
            g.scoreClickedChannelIndex= selectedChannelIndex;
            g.scoreClickedEegValue = clickedEegValue;
        elseif strcmp(g.scoreAnnotationState, 'WaitingForClick2')
            g.scoreAnnotationState = 'WaitingForClick3';
            g.scoreClickedTime = clickedTime;
            g.scoreClickedSample = [g.scoreClickedSample clickedSample];
            
        elseif strcmp(g.scoreAnnotationState, 'WaitingForClick3')
            g.scoreAnnotationState = 'WaitingForClick4';
            g.scoreClickedTime = clickedTime;
            g.scoreClickedSample = [g.scoreClickedSample clickedSample];
            
        elseif strcmp(g.scoreAnnotationState, 'WaitingForClick4')
            %We have a second click, so we now have a start and stop
            g.scoreAnnotationState = 'WaitingForFirstClick';  
            g.scoreClickedSample = [g.scoreClickedSample clickedSample];
            clickedSamples = g.scoreClickedSample;
            clickedChannel = g.scoreClickedChannelIndex;
            dataSegment = EEG.data(clickedChannel, clickedSamples(1):clickedSamples(2));
            [ymax ymaxsample] = max(dataSegment);
            allFigures = findall(0,'type','figure');
            oneEventDetails = findobj(allFigures, 'tag', 'oneEventDetails');
            if ~isempty(oneEventDetails)                
                handles = guidata(oneEventDetails);
                if isfield(handles, 'SearchResultEventId')                    
                    configData = ScoreGetAnnotationsForOneProject(handles.SearchResultId);
                    if strcmp(configData,'No Data')
                        warning(['No annotation configurations have been set up']);
                    else
                        [spikeStart, spikeCenter,spikeEnd, afterDischargeEnd, clickedChannel] = GetClickableAnnotationConfigForSTATAFocalEpi(handles.SearchResultId);                        
                        if ~isempty(spikeStart)
                            ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, spikeStart,'ValueInt',clickedSamples(1));
                        else
                            warning(['Annotation configuration SpikeStart not found']);
                        end
                        if ~isempty(spikeCenter)
                            ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, spikeCenter,'ValueInt',clickedSamples(2));
                        else
                            warning(['Annotation configuration SpikeCenter not found']);
                        end  
                        if ~isempty(spikeEnd)
                            ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, spikeEnd,'ValueInt',clickedSamples(3));
                        else
                            warning(['Annotation configuration SpikeEnd not found']);
                        end 
                        if ~isempty(afterDischargeEnd)
                            ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, afterDischargeEnd,'ValueInt',clickedSamples(4));
                        else
                            warning(['Annotation configuration AfterDischargeEnd not found']);
                        end  
                        if ~isempty(afterDischargeEnd)
                            ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, afterDischargeEnd,'ValueInt',clickedSamples(4));
                        else
                            warning(['Annotation configuration AfterDischargeEnd not found']);
                        end  
                        if ~isempty(clickedChannel)
                            ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, clickedChannel,'ValueInt',clickedChannel);
                        else
                            warning(['Annotation configuration clickedChannel not found']);
                        end  
                    end                     
                    
                end
                handles.UpdateCustomAnnotations(handles);
            end
            
        end
    end
    
    set(gcf, 'UserData', g);
    %guidata(gcf, g);
    
end