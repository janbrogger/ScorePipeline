
ft_read_header('C:\LocalDB\Workarea\45166\Patient6t1.e');



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




