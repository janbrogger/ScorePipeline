function ScoreInsertVerticalScaleEye()
    DEFAULT_AXIS_COLOR = 'k';         % X-axis, Y-axis Color, text Color
    VSPACING_UNITS_STRING = 'µV';
    HSPACING_UNITS_STRING = 's';
    if exist('EEG', 'var')
        error('No EEG open in EEGLAB');
    end
    
    existingPlot = ScoreGetEeglabPlot();
    if isempty(existingPlot)        
        warning('No EEG plot open in EEGLAB, cannot insert SCORE scale eye');    
    else 
        %Code taken mostly from eegplot.m
        g = get(existingPlot,'UserData');	
        eyeaxes = findobj('tag','eyeaxes','parent',existingPlot);
        ax1 = findobj('tag','eegaxis','parent',gcf); % axes handle
        YLim = double(get(ax1, 'ylim'));
        XLim = double(get(ax1, 'xlim'));

        ESpacing = findobj('tag','ESpacing','parent',existingPlot);
        g.spacing= str2double(get(ESpacing,'string'));

        axes(eyeaxes); cla; axis off;
        set(eyeaxes, 'ylim', YLim);
        %set(eyeaxes, 'xlim', XLim);

        spacingFactor = 4;
        Xl = double([.35 .65; .50 .50; .35 .65; ]* (XLim(2)-XLim(1)) + XLim(1));
        Yl = double([ g.spacing*spacingFactor g.spacing*spacingFactor; 
                      g.spacing*spacingFactor 0; 
                      0 0; ] + YLim(1));
        VSCALETEXT_YFACTOR1 = 23;
        VSCALETEXT_YFACTOR2 = 10;        
        %the next line is the vertical top cap line
        plot(Xl(1,:),Yl(1,:),'color',DEFAULT_AXIS_COLOR,'clipping','off', 'tag','eyeline'); hold on;
        %the next line is the vertical line
        plot(Xl(2,:),Yl(2,:),'color',DEFAULT_AXIS_COLOR,'clipping','off', 'tag','eyeline');
        %the next line is the vertical bottom cap line
        plot(Xl(3,:),Yl(3,:),'color',DEFAULT_AXIS_COLOR,'clipping','off', 'tag','eyeline');

        
        text(.5*(XLim(2)-XLim(1)) + XLim(1),((YLim(2)-YLim(1))/VSCALETEXT_YFACTOR1+Yl(1)),num2str(g.spacing*spacingFactor,4),...
             'HorizontalAlignment','center','FontSize',10,...
             'tag','thescalenum')
        text(Xl(2)*1.30,Yl(1),'+','HorizontalAlignment','left',...
             'verticalalignment','middle', 'tag', 'thescale')
        text(Xl(2)*1.30,Yl(4),'-','HorizontalAlignment','left',...
             'verticalalignment','middle', 'tag', 'thescale')
        if ~isempty(VSPACING_UNITS_STRING)
             text(.7* (XLim(2)-XLim(1)) + XLim(1),-YLim(2)/VSCALETEXT_YFACTOR1+Yl(1),VSPACING_UNITS_STRING,...
                 'HorizontalAlignment','center','FontSize',10, 'tag', 'thescale')
        end
        text(.5* (XLim(2)-XLim(1)) + XLim(1),(YLim(2)-YLim(1))/VSCALETEXT_YFACTOR2+Yl(1),'Scales',...
             'HorizontalAlignment','center','FontSize',10, 'tag', 'thescale')                          
        set(eyeaxes, 'tag', 'eyeaxes');
    end
end