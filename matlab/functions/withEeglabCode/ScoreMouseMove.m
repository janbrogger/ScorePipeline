function data = ScoreMouseMove(varargin)
    g = get(gcf,'UserData');
    if isfield(g,'projectSpecificMouseMove')
        projectSpecificMouseMove = g.projectSpecificMouseMove;
        if ~strcmp(projectSpecificMouseMove,'null')
            eval(projectSpecificMouseMove);
        end
    else
        %warning('The variable projectSpecificMouseMove has not been initialized on this EEGLAB plot');
    end
end