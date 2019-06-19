function data = ScoreMouseUp(varargin)
    g = get(gcf,'UserData');
    projectSpecificMouseUp = getfield(g, 'projectSpecificMouseUp');
    if ~strcmp(projectSpecificMouseUp,'null')
        eval(projectSpecificMouseMove);
    end
end
