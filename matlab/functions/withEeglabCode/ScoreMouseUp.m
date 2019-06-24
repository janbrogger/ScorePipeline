function data = ScoreMouseUp(varargin)
    g = get(gcf,'UserData');
    if isfield(g,'projectSpecificMouseUp')
        projectSpecificMouseUp = g.projectSpecificMouseUp;
        if ~strcmp(projectSpecificMouseUp,'null')
            eval(projectSpecificMouseMove);
        end
    else
        warning('The variable projectSpecificMouseUp has not been initialized on this EEGLAB plot');
    end
end
