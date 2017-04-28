function data = ScoreMouseDown(varargin)

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
            g.scoreAnnotationState = 'WaitingForSecondClick';
            g.scoreClickedTime = clickedTime;
            g.scoreClickedSample = clickedSample;
            g.scoreClickedChannelIndex= selectedChannelIndex;
            g.scoreClickedEegValue = clickedEegValue;
        elseif strcmp(g.scoreAnnotationState, 'WaitingForSecondClick')
            %We have a second click, so we now have a start and stop
            g.scoreAnnotationState = 'WaitingForFirstClick';            
            clickedSamples(1) = g.scoreClickedSample;
            clickedSamples(2) = clickedSample;
            clickedChannel = g.scoreClickedChannelIndex;
            dataSegment = EEG.data(clickedChannel, clickedSamples(1):clickedSamples(2));
            [ymax ymaxsample] = max(dataSegment);
            allFigures = findall(0,'type','figure');
            oneEventDetails = findobj(allFigures, 'tag', 'oneEventDetails');
            if ~isempty(oneEventDetails)                
                handles = guidata(oneEventDetails);
                if isfield(handles, 'SearchResultEventId')                    
                    configData = ScoreGetAnnotationsForOneProject(handles.SearchResultId);
                    if ~strcmp(configData,'No Data')
                        [searchResultAnnotationConfigIdSampleStart, searchResultAnnotationConfigIdSampleEnd, searchResultAnnotationConfigIdScreenshot] = GetClickableAnnotationConfig(handles.SearchResultId);                        
                        if ~isempty(searchResultAnnotationConfigIdSampleStart)
                            ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, searchResultAnnotationConfigIdSampleStart,'ValueInt',clickedSamples(1));
                        end
                        if ~isempty(searchResultAnnotationConfigIdSampleEnd)
                            ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, searchResultAnnotationConfigIdSampleEnd,'ValueInt',clickedSamples(2));
                        end    
                        if ~isempty(searchResultAnnotationConfigIdScreenshot)
                            tempFileName = tempname();
                            [pathstr, name, ext] = fileparts(tempFileName);
                            tempFileName = [pathstr name '.png'];                        
                            print(tempFileName,'-dpng','-r0')
                            disp(tempFileName);
                            fileID = fopen(tempFileName,'r');
                            if fileID ~= -1            
                                png = fread(fileID);
                                fclose(fileID);                            
                                ScoreSetAnnotationForOneEvent(handles.SearchResultEventId, ...
                                    searchResultAnnotationConfigIdScreenshot, ...
                                    'ValueBlob', png);                    
                            else
                                warning(['Could not read screenshot file ' tempFileName]);
                            end                            
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