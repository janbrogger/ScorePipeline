function existingPlot = ScoreGetEeglabPlot()
        
    existingPlot = findobj(0, 'tag', 'EEGPLOT');
    if isempty(existingPlot)
        warning('No EEG plot open in EEGLAB');
    elseif size(existingPlot,1)>1        
        warn('More than one EEGPLOT open, using the first one');        
        existingPlot = existingPlot(1);        
    end    
end
