function ScorePrintHeader()    
    disp(' ')
    disp('SCORE quantification pipeline')
    disp('-----------------------------');
    [scorePipelineVersion, date] = ScorePipelineVersion();
    disp(['by Jan Brogger. Version ' scorePipelineVersion ' ' date]);
    disp(' ');
end

function [scorePipelineVersion, date] = ScorePipelineVersion()
    scorePipelineVersion = '0.2';
    date = '2016-12-08';    
end