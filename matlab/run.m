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


pop_fileio([scoreBasePath 'janbrogger.e']);
pop_fileio([scoreBasePath 'Patient15_EEG246_t1.e']);

header = ft_read_header('C:\Users\Jan\Documents\GitHub\ScorePipeline\janbrogger.e');

ft_read_header([scoreBasePath 'janbrogger.e']);
ft_read_header([scoreBasePath 'Patient15_EEG246_t1.e']);

eegDir = 'C:\LocalDB\Workarea\';
eegdirlist = dir(eegDir);
j = 1;
for i=3:size(eegdirlist,1)        
     if eegdirlist(i).isdir   
         eegdirlist2 = dir([eegDir eegdirlist(i).name '\*.e']);  
         for k=1:size(eegdirlist2,1)    
             oneeeg = [eegDir eegdirlist(i).name '\' eegdirlist2(k).name];
             disp(oneeeg);
             eeglist{j} = oneeeg;
             j = j + 1;
         end        
     end
end

for i=1:size(eeglist,2)
    disp(eeglist(i));
    ft_read_header(eeglist(i));
end
