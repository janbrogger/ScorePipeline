function ScoreMouseMove(varargin)    

    %g = get(gcf,'UserData');    
    %EEG = evalin('base','EEG');        
    %figPoint = get(gcf,'CurrentPoint');
    %figPoint = hgconvertunits(gcf,[figPoint 0 0],get(gcf,'Units'),'pixels',gcf);
    %figPoint = figPoint(1:2);
    %fprintf(' %2.5f %2.5f\n', figPoint(1), figPoint(2));
    
    
    
    g = get(gcf,'UserData');
    cp = get(gca,'currentpoint');
    EEG = evalin('base','EEG');
    [clickedTime, clickedSample, selectedChannelIndex, clickedEegValue] = ScoreGetClickedTraceFromPoint(cp);    
    
    if ~isempty(clickedTime)
        disp(['Clicked elapsed time : ' num2str(clickedTime)]);  
        disp(['Clicked sample : ' num2str(clickedSample)]);  
        disp(['Current time position at left is ' num2str(g.time)]);
        disp(['Current time position at right is ' num2str(g.time+g.winlength*g.srate)]);    
        disp([' Selected channel ' EEG.chanlocs(selectedChannelIndex).labels ' ,closest EEG value ' num2str(clickedEegValue) ]);    
    end
    
end