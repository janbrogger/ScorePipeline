function ScoreMouseMove(varargin)    

    g = get(gcf,'UserData');
    cp = get(gca,'currentpoint');
    EEG = evalin('base','EEG');
    eegaxis = findobj('tag', 'eegaxis', 'parent', gcf);
    
    ylim = get(eegaxis, 'ylim');
        
    [currentTime, currentSample, currentChannelIndex, currentEegValue] = ScoreGetClickedTraceFromPoint(cp);        
    
    if ~isfield(g, 'scoreAnnotationState') || isempty(g.scoreAnnotationState)
            g.scoreAnnotationState = 'WaitingForFirstClick';        
    end
    
    if ~isempty(currentTime)
        %disp(['Clicked elapsed time : ' num2str(clickedTime) ' Clicked sample : ' num2str(clickedSample) ]);  
        %disp(['Current time position at left is ' num2str(g.time) ' , at right is ' num2str(g.time+g.winlength*g.srate)]);
        %disp([' Selected channel ' EEG.chanlocs(selectedChannelIndex).labels ' ,closest EEG value ' num2str(clickedEegValue) ]);
                
        hold(eegaxis, 'on');
        vlineindicator = findobj('tag', 'vlineindicator', 'parent', eegaxis);
        if ~isempty(vlineindicator)
            delete(vlineindicator);
        end
        plot(eegaxis, [currentSample-g.time*g.srate currentSample-g.time*g.srate],[ ylim(1) ylim(2)], ...
            'tag', 'vlineindicator', 'Color', 'blue', ...
            'linewidth', 2);
        hold(eegaxis, 'off');
    
        lines = findobj('type', 'Line', 'parent', eegaxis);
        actualIndex = 0;
        for i = 1:size(lines, 1)
            if  ~strcmp(get(lines(i),'tag'),'vlineindicator')
                if  size(lines(i).XData,2)>2 
                    actualIndex = actualIndex+1;
                    if actualIndex == currentChannelIndex
                        set(lines(i),'LineWidth', 2);                
                        set(lines(i),'Color', 'red');
                    else
                        set(lines(i),'LineWidth', 1);                
                        set(lines(i),'Color', 'black');
                    end                        
                end
            end
        end    
        
        %Plot to indicate the selection of current segment of EEG
        if strcmp(g.scoreAnnotationState, 'WaitingForSecondClick')            
            hold(eegaxis, 'on');
            selectindicator = findobj('tag', 'selectindicator', 'parent', eegaxis);
            if ~isempty(selectindicator)
                delete(selectindicator);
            end
            numberOfChannels = size(EEG.data,1);            
            upsideDownChannelIndex = numberOfChannels-g.scoreClickedChannelIndex;
            yvalue1 = EEG.data(g.scoreClickedChannelIndex,g.scoreClickedSample) ...
                +g.spacing*(upsideDownChannelIndex+1);
            plot(eegaxis, ...
                [g.scoreClickedSample-g.time*g.srate ...
                 currentSample-g.time*g.srate], ...
                [yvalue1 yvalue1 ], ...
                'tag', 'selectindicator', 'Color', 'green', ...
                'linewidth', 2);
            hold(eegaxis, 'off');
        end
        
    else
        lines = findobj('type', 'Line', 'parent', eegaxis);
        for i = 1:size(lines, 1)
            if  ~strcmp(get(lines(i),'tag'),'vlineindicator') ...
                && ~strcmp(get(lines(i),'tag'),'selectindicator')
                set(lines(i),'LineWidth', 1);
                set(lines(i),'Color', 'black');
            end
        end        
    end    
end