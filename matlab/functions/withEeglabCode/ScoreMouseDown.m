function data = ScoreMouseDown(varargin)
    g = get(gcf,'UserData');
    if isfield(g,'projectSpecificMouseDown')
        projectSpecificMouseDown = g.projectSpecificMouseDown;
        if ~strcmp(projectSpecificMouseDown,'null')
            eval(projectSpecificMouseDown);
        end
    else
        warning('The variable projectSpecificMouseDown has not been initialized on this EEGLAB plot');
    end
end
