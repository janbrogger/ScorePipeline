function data = ScoreMouseDown(varargin)
    g = get(gcf,'UserData');
    projectSpecificMouseDown = getfield(g, 'projectSpecificMouseDown');
    if ~strcmp(projectSpecificMouseDown,'null')
        eval(projectSpecificMouseDown);
    end
end
