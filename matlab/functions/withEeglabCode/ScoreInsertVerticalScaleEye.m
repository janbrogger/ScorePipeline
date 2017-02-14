function ScoreInsertVerticalScaleEye()
    DEFAULT_AXIS_COLOR = 'k';         % X-axis, Y-axis Color, text Color
    SPACING_UNITS_STRING = 'µV';
    if exist('EEG', 'var')
        error('No EEG open in EEGLAB');
    end
    
    existingPlot = ScoreGetEeglabPlot();
    if isempty(existingPlot)        
        warning('No EEG plot open in EEGLAB, cannot insert SCORE scale eye');    
    else
        %eegplot('scaleeye', 'off', existingPlot);        
        
        %Code taken mostly from eegplot.m
        g = get(existingPlot,'UserData');	
        eyeaxes = findobj('tag','eyeaxes','parent',existingPlot);
        ax1 = findobj('tag','eegaxis','parent',gcf); % axes handle
        YLim = double(get(ax1, 'ylim'));

        ESpacing = findobj('tag','ESpacing','parent',existingPlot);
        g.spacing= str2num(get(ESpacing,'string'));

        axes(eyeaxes); cla; axis off;
        set(eyeaxes, 'ylim', YLim);

        spacingFactor = 4;
        Xl = double([.35 .65; .5 .5; .35 .65]);
        Yl = double([ g.spacing*spacingFactor g.spacing*spacingFactor; g.spacing*spacingFactor 0; 0 0] + YLim(1));
        plot(Xl(1,:),Yl(1,:),'color',DEFAULT_AXIS_COLOR,'clipping','off', 'tag','eyeline'); hold on;
        plot(Xl(2,:),Yl(2,:),'color',DEFAULT_AXIS_COLOR,'clipping','off', 'tag','eyeline');
        plot(Xl(3,:),Yl(3,:),'color',DEFAULT_AXIS_COLOR,'clipping','off', 'tag','eyeline');
        text(.5,((YLim(2)-YLim(1))/23+Yl(1)),num2str(g.spacing*spacingFactor,4),...
             'HorizontalAlignment','center','FontSize',10,...
             'tag','thescalenum')
        text(Xl(2)+.1,Yl(1),'+','HorizontalAlignment','left',...
             'verticalalignment','middle', 'tag', 'thescale')
        text(Xl(2)+.1,Yl(4),'-','HorizontalAlignment','left',...
             'verticalalignment','middle', 'tag', 'thescale')
        if ~isempty(SPACING_UNITS_STRING)
             text(.5,-YLim(2)/23+Yl(4),SPACING_UNITS_STRING,...
                 'HorizontalAlignment','center','FontSize',10, 'tag', 'thescale')
        end
        text(.5,(YLim(2)-YLim(1))/10+Yl(1),'SCORE scale',...
             'HorizontalAlignment','center','FontSize',10, 'tag', 'thescale')
        set(eyeaxes, 'tag', 'eyeaxes');
    end
end