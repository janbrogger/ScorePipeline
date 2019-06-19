function data = ScoreMouseMove(varargin)
    g = get(gcf,'UserData');
    projectSpecificMouseMove = getfield(g, 'projectSpecificMouseMove');
    if ~strcmp(projectSpecificMouseMove,'null')
        eval(projectSpecificMouseMove);
    end
end