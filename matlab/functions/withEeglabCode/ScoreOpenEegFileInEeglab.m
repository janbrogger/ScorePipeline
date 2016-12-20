function ScoreOpenEegFileInEeglab(newFilePath, searchResultEventId)
    disp(['Opening new EEG file ' newFilePath]);    
    %Start up EEGLAB if pop_fileio is not in the path   
    if not(exist('pop_fileio', 'file'))
        eeglab
    end
    %Close any existing plot
    existingPlot = findobj(0, 'tag', 'EEGPLOT');
    if not(isempty(existingPlot))
        close(existingPlot.Number)
    end
    
    if not(exist(newFilePath, 'file'))
        assignin('base','STUDY', []); 
        assignin('base','CURRENTSTUDY', 0); 
        assignin('base','ALLEEG', []); 
        assignin('base','EEG', []); 
        assignin('base','CURRENTSET', []);         
    else        
        EEG = pop_fileio(newFilePath);        
        EEG.setname='test';    
        EEG = pop_select( EEG,'nochannel',{'Photic' 'Rate' 'IBI' 'Bursts' 'Suppr'});    
        ekgindex = find(strcmp({EEG.chanlocs(:).labels}, 'EKG'));
        EEG = pop_reref( EEG, [],'exclude',ekgindex);  
        
        eventsToChangeDuration = find(strcmp({EEG.event(:).value},'Review progress'));
        EEG.event(eventsToChangeDuration).duration = 0;
        
        for i=1:size(EEG.event,2)
            for j=1:size(ScoreConfig.eventGuids)  
                if length(EEG.event(i).type) >= 36
                    if strcmp(EEG.event(i).type(1:36), ScoreConfig.eventGuids(j,1))
                        EEG.event(i).value = ScoreConfig.eventGuids{j,2};
                        EEG.event(i).type = ScoreConfig.eventGuids{j,2};
                    end                
                end
            end
        end
        
        %Downscale EEG
        EEG.data(ekgindex,:) = EEG.data(ekgindex,:)/5;
        % high-pass filter at 0.5 Hz
        %EEG = pop_eegfilt( EEG, 0.5, 0, [], [0]);
        % low-pass filter at 70 Hz
        %EEG = pop_eegfilt( EEG, 0, 70, [], [0]);        
        %EEG = pop_eegfilt( EEG, 0.5, 70, [], [0], 0, 0, 'fir1', 0);
              
        
        
        pop_eegplot( EEG, 1, 1, 1);
        clear ekgindex
        EEG.filename = ['searchResultEventId = ' num2str(searchResultEventId)];
        assignin('base','EEG',EEG);
        eeg_checkset( EEG );  
        evalin('base', 'eeglab redraw');
                
        ScoreGotoEvent(searchResultEventId);                        
    end
end
