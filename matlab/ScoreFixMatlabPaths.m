function ScoreFixMatlabPaths()

    if not(exist(ScoreConfig.scoreBasePath, 'dir'))
        error(['Fix your ScoreConfig.m file - the SCORE base path was not found: ' ScoreConfig.scoreBasePath]);
    end

    ScoreFixMatlabPath('matlab\functions');
    ScoreFixMatlabPath('matlab\functions\withEeglabCode');
    ScoreFixMatlabPath('matlab\gui');
end

function ScoreFixMatlabPath(scoreSubDir)
    pathCell = regexp(path, pathsep, 'split');
    lookforFolder = [ScoreConfig.scoreBasePath '\' scoreSubDir];
    if ispc  % Windows is not case-sensitive
        onPath = any(strcmpi(lookforFolder, pathCell));
    else
      onPath = any(strcmp(lookforFolder, pathCell));
    end
    
    %disp(['Looked for folder ' lookforFolder ': result = ' num2str(onPath)]);
    if onPath == 0
        evalin('base', ['addpath (''' lookforFolder ''');']);                  
    end
    
    
end