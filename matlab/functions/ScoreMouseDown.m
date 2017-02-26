function data = ScoreMouseDown(varargin)

    g = get(gcf,'UserData');
    cp = get(gca,'currentpoint');
    EEG = evalin('base','EEG');
    [clickedTime, clickedSample, selectedChannelIndex, clickedEegValue] = ScoreGetClickedTraceFromPoint(cp);    
    
    disp(['Clicked elapsed time : ' num2str(clickedTime)]);  
    disp(['Clicked sample : ' num2str(clickedSample)]);  
    disp(['Current time position at left is ' num2str(g.time)]);
    disp(['Current time position at right is ' num2str(g.time+g.winlength*g.srate)]);    
    disp([' Selected channel ' EEG.chanlocs(selectedChannelIndex).labels ' ,closest EEG value ' num2str(clickedEegValue) ]);    
        
end