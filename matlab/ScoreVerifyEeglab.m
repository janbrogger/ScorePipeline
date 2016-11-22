function ScoreVerifyEeglab()
   
   addpath(ScoreConfig.eeglabPath);
   addpath([ScoreConfig.eeglabPath '\plugins']);
   addpath([ScoreConfig.eeglabPath '\functions']);
   addpath([ScoreConfig.eeglabPath '\functions\adminfunc']);
    if not(exist('eeglab'))
        error('EEGLAB not found in Matlab path');
    else
        disp('EEGLAB found in Matlab path');
    end
        
    if exist([ScoreConfig.eeglabPath '\plugins\Fileio161116'], 'dir')==0        
        disp('EEGLAB plugin fileio not found, trying to install');
        %plugin_install('http://sccn.ucsd.edu/eeglab/plugins/fileio-20161116.zip', 'Fileio', '161116', 1);
        plugin_askinstall('Fileio', 'ft_read_data', 1);
    else
        disp('EEGLAB plugin fileio found');
    end
end
