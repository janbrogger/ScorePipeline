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
    
    eegaxis = findobj('tag', 'eegaxis', 'parent', gcf);
    lines = findobj('type', 'Line', 'parent', eegaxis);
    actualIndex = 0;
    for i = 1:size(lines, 1)
        if  size(lines(i).XData,2)>2 
            actualIndex = actualIndex+1;
            if actualIndex == selectedChannelIndex
                set(lines(i),'LineWidth', 2);                
                set(lines(i),'Color', 'red');
            else
                set(lines(i),'LineWidth', 1);                
                set(lines(i),'Color', 'black');
            end                        
        end
    end        
end