
function [scorePath] = SetupScorePipeline()
    %SetupScorePipeline Sets up SCORE pipeline
    %   by adding Eeglab and Nicolet Matlab SDK to the path
    NicoletSDKpath = 'NicoletSDK_20110718\MFiles';
    eeglabPath = 'eeglab_current';
    
    scorePath = '';
    if (strcmp(getenv('UserDomain'), 'Jan-PC'))
        scorePath = [getenv('UserProfile'), '\Documents\GitHub\ScorePipeline\matlab\'];
    elseif (strcmp(getenv('UserDomain'), 'HS'))
        scorePath = 'J:\ScorePipeline\matlab\';
    end

    if (strcmp(scorePath, ''))
        disp('Do not know the base path on this machine')
    elseif  not(exist(scorePath,'dir'))
        disp(['Working folder not found:', scorePath]);
    else
        cd(scorePath)
        if  not(exist([scorePath, NicoletSDKpath], 'dir'))
            disp(['Nicolet SDK not found - unzip the archive? Expected at ', [scorePath, NicoletSDKpath]]);
        else
            disp(['Nicolet SDK found at: ', [scorePath, NicoletSDKpath]]);
        end
        if  not(exist([scorePath, eeglabPath], 'dir'))
            disp(['Eeglab not found - unzip the archive? Expected at ', [scorePath, eeglabPath]]);
        else
            disp(['Eeglab found at: ', [scorePath, eeglabPath]]);
        end
        
        if and(exist([scorePath, NicoletSDKpath], 'dir'), exist([scorePath, eeglabPath], 'dir'))
            addpath([scorePath, NicoletSDKpath]);
            addpath([scorePath, eeglabPath]);
            disp('Setup complete');
        end
    end
        

end

