scoreBasePath = SetupScorePipeLinePath();
scoreData = ReadScoreExtractDb(scoreBasePath);
disp(['Number of epileptiform findings: ' num2str(sum(scoreData.IsEpileptiform))])
disp(['Number of non-epileptiform findings: ' num2str(sum(scoreData.IsNonEpiSharp))])

scoreData = CheckScoreEegFileExists(scoreData);

disp('Fields in the scoreData structure');
fields(scoreData)

pop_fileio

disp('Trying import of one EEG file using EEGLAB-fileio');
pop_fileio('\\hbemta-nevrofil01.knf.local\Rutine\workarea\25001-30000\25001\Patient7t1.e');