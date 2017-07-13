%This is to get the EEG data for this event:
%SearchResultEventId	8
%Event time	2012-01-24 13:18:59.877
%Time in seconds minus gaps	379.9
%File path	\\hbemta-nevrofil01.knf.local\RutineArkiv1\40001-45000\44157\Patient2_EEG246_t1.e
%File status	EEG file was found
%EEGLAB status	EEG plot found
%Current EEG position	24-Jan-2012 13:18:59

%SpikeStartSample	Int	1901120
%SpikeEndSample	Int	1902690

struct2table(EEG.chanlocs)
EEG.chanlocs(:).labels
indexOfT3 = strmatch('T3',{EEG.chanlocs(:).labels});
annotationDataOneChannel = EEG.data(indexOfT3, 190112:190269);

waveletAnalyzer
%open the wavelet analyzer, load the data now in annotationDataOneChannel
