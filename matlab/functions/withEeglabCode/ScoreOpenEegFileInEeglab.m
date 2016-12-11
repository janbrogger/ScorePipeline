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
        EEG = pop_eegfilt( EEG, 0.5, 70, [], [0], 0, 0, 'fir1', 0);
        EEG = eeg_checkset( EEG );        
        pop_eegplot( EEG, 1, 1, 1);
        clear ekgindex
        EEG.filename = ['searchResultEventId = ' num2str(searchResultEventId)];
        assignin('base','EEG',EEG);
        evalin('base', 'eeglab redraw');
    end
end
