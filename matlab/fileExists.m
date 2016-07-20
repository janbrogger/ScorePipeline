%fullPath = strcat(scoreData.FilePath(1),'\',scoreData.FileName(1))
%exist(fullPath{1}, 'file')
scoreData = SetupScoreExtractDb('J:\ScorePipeline\')
scoreData.FileIndex = cell(size(scoreData.FilePath,1),1);



for i=1:1:size(scoreData.FilePath)    
    scoreData.FilePath(i) = strrep(scoreData.FilePath(i),'\\batman.knf.local\','\\hbemta-nevrofil01.knf.local\');    
    fileIndex = regexp(scoreData.FilePath(i),'\\([0-9][0-9][0-9][0-9][0-9])$','tokens');    
    if ~isempty(fileIndex{1})
        scoreData.FileIndex(i)= fileIndex{1}{1};
    end
end



for i=1:1:size(scoreData.FilePath)    
    %fullPath = strcat(scoreData.FilePath(i),'\',scoreData.FileName(i));
    %scoreData.FileExists(i) = exists(fullPath, 'file');    
    %scoreData.FileExists(i) = exist(fullPath{1}, 'file');
end