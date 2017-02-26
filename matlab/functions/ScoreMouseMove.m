function ScoreMouseMove(varargin)    

    g = get(gcf,'UserData');
    cp = get(gca,'currentpoint');
    EEG = evalin('base','EEG');
    eegaxis = findobj('tag', 'eegaxis', 'parent', gcf);
    
    ylim = get(eegaxis, 'ylim');
        
    [clickedTime, clickedSample, selectedChannelIndex, clickedEegValue] = ScoreGetClickedTraceFromPoint(cp);        
    
    if ~isempty(clickedTime)
        disp(['Clicked elapsed time : ' num2str(clickedTime) ' Clicked sample : ' num2str(clickedSample) ]);  
        disp(['Current time position at left is ' num2str(g.time) ' , at right is ' num2str(g.time+g.winlength*g.srate)]);
        disp([' Selected channel ' EEG.chanlocs(selectedChannelIndex).labels ' ,closest EEG value ' num2str(clickedEegValue) ]);
                
        hold(eegaxis, 'on');
        vlineindicator = findobj('tag', 'vlineindicator', 'parent', eegaxis);
        if ~isempty(vlineindicator)
            delete(vlineindicator);
        end
        plot(eegaxis, [clickedSample-g.time*g.srate clickedSample-g.time*g.srate],[ ylim(1) ylim(2)], ...
            'tag', 'vlineindicator', 'Color', 'blue', ...
            'linewidth', 2);
        hold(eegaxis, 'off');
    
        lines = findobj('type', 'Line', 'parent', eegaxis);
        actualIndex = 0;
        for i = 1:size(lines, 1)
            if  ~strcmp(get(lines(i),'tag'),'vlineindicator')
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
    else
        lines = findobj('type', 'Line', 'parent', eegaxis);
        for i = 1:size(lines, 1)
            if  ~strcmp(get(lines(i),'tag'),'vlineindicator')
                set(lines(i),'LineWidth', 1);
                set(lines(i),'Color', 'black');
            end
        end        
    end    
end