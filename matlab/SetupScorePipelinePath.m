
function [scoreBasePath] = SetupScorePipelinePath()
    %SetupScorePipeline Sets up SCORE pipeline
    %   by adding Eeglab to the path    
    eeglabPath = 'eeglab_current';
    
    scoreBasePath = '';
    if (strcmp(getenv('UserDomain'), 'Jan-PC'))
        scoreBasePath = [getenv('UserProfile'), '\Documents\GitHub\ScorePipeline\'];
    elseif (strcmp(getenv('UserDomain'), 'HS'))
        scoreBasePath = 'J:\ScorePipeline\';
    end

    if (strcmp(scoreBasePath, ''))
        disp('Do not know the base path on this machine')
    elseif  not(exist(scoreBasePath,'dir'))
        disp(['Working folder not found:', scorePath]);
    else
        scoreMatlabPath = [scoreBasePath '\matlab\'];
        cd(scoreMatlabPath)
        
        if  not(exist([scoreMatlabPath, eeglabPath], 'dir'))
            disp(['Eeglab not found - unzip the archive? Expected at ', [scoreMatlabPath eeglabPath]]);
        else
            disp(['Eeglab found at: ', [scoreMatlabPath eeglabPath]]);
        end
        
        if exist([scoreMatlabPath, eeglabPath], 'dir')            
            addpath([scoreMatlabPath, eeglabPath]);
            disp('Setup complete');
        end
    end        
end

