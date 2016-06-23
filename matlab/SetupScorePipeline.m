
function [] = SetupScorePipeline()
    %SetupScorePipeline Sets up SCORE pipeline
    %   by adding Eeglab and Nicolet Matlab SDK to the path
    NicoletSDKpath = 'NicoletSDK_20110718\MFiles';
    eeglabPath = 'eeglab_current';
    
    myPath = '';
    if (strcmp(getenv('UserDomain'), 'Jan-PC'))
        myPath = [getenv('UserProfile'), '\Documents\GitHub\ScorePipeline\matlab\']
    elseif (strcmp(getenv('UserDomain'), 'ihelse.net'))
        myPath = ''
    end

    if (strcmp(myPath, ''))
        disp('Do not know the base path on this machine')
    elseif  not(exist(myPath,'dir'))
        disp(['Working folder not found:', myPath]);
    else
        cd(myPath)
        if  not(exist([myPath, NicoletSDKpath], 'dir'))
            disp(['Nicolet SDK not found - unzip the archive? Expected at ', [myPath, NicoletSDKpath]]);
        else
            disp(['Nicolet SDK found at: ', [myPath, NicoletSDKpath]]);
        end
        if  not(exist([myPath, eeglabPath], 'dir'))
            disp(['Eeglab not found - unzip the archive? Expected at ', [myPath, eeglabPath]]);
        else
            disp(['Eeglab found at: ', [myPath, eeglabPath]]);
        end
        
        if and(exist([myPath, NicoletSDKpath], 'dir'), exist([myPath, eeglabPath], 'dir'))
            addpath([myPath, NicoletSDKpath]);
            addpath([myPath, eeglabPath]);
            disp('Setup complete');
        end
    end
        

end

