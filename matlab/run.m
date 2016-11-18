%Now setup paths to EEGLAB, and update fieldtrip in EEGLAB if necessary
scoreBasePath = 'C:\Users\Jan\Documents\GitHub\ScorePipeline\';
addpath([scoreBasePath 'matlab']);

%Test the ODBC connection to the SCORE anonymized database that we need

setdbprefs('DataReturnFormat','cellarray')
ScoreVerifyTableExist('SearchResult');
ScoreVerifyTableExist('SearchResult_Study');
            
%Update the fieldtrip plugin in EEGLAB
cd([scoreBasePath '\matlab']);
system([scoreBasePath 'update-fieldtrip-in-eeglab.bat'])
%Add eeglab to path
eeglabPath = 'C:\Users\Jan\Documents\GitHub\eeglab';
addpath(eeglabPath);


scoreData = ReadScoreExtractDb(scoreBasePath);
disp(['Number of epileptiform findings: ' num2str(sum(scoreData.IsEpileptiform))])
disp(['Number of non-epileptiform findings: ' num2str(sum(scoreData.IsNonEpiSharp))])

%scoreData = CheckScoreEegFileExists(scoreData);

disp('Fields in the scoreData structure');
fields(scoreData)


%Read each file to test for read success
j = 1;
%for i=1:size(eeglist,2)    
    disp([num2str(j) ' ' datestr(now) ' ' eeglist(i).filename]);
    try        
        ft_read_header(eeglist(i).filename);
        eeglist(i).opensuccess = 1;
    catch
        eeglist(i).opensuccess = 0;
    end     
    j = j+1;
end

struct2table(eeglist);

%Process one file
eeglab
% Read the file
EEG = pop_fileio('C:\LocalDB\Workarea\45197\Patient6_EEG226_t1.e');
EEG.setname='test';
% Drop some irrelevant channels
EEG = pop_select( EEG,'nochannel',{'Photic' 'Rate' 'IBI' 'Bursts' 'Suppr'});
% Rereference to common average, except EKG
ekgindex = find(strcmp({EEG.chanlocs(:).labels}, 'EKG'));
EEG = pop_reref( EEG, [],'exclude',ekgindex);
% Filter lowpass 0.5-70 Hz
EEG = pop_eegfilt( EEG, 0.5, 70, [], [0], 0, 0, 'fir1', 0);
EEG = eeg_checkset( EEG );
eeglab redraw
pop_eegplot( EEG, 1, 1, 1);




