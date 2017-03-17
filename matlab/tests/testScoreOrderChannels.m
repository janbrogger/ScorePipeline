%Common variables
testChannelsNum = 24;
EEG = struct();
EEG.data = zeros(testChannelsNum,10);
chanlocs = struct();
originalOrder = {'Fp1', 'Fp2', 'F3', 'F4', 'C3', ...
                 'C4', 'P3', 'P4', 'O1', 'O2', ...
                 'F7', 'F8', 'T3', 'T4', 'T5', ...
                 'T6', 'A1', 'A2', 'Fz', 'Cz', ...
                 'Pz', 'Fpz', 'EKG', 'Photic'};
for i=1:size(originalOrder,2)
    chanlocs(i).labels = originalOrder{i};
end    
EEG.chanlocs = chanlocs;

%% Test 1: Empty montage order
%resultEEG = ScoreOrderChannels(EEG, []);
%for i=1:size(EEG.chanlocs,1)
%    assert(strcmp(EEG.chanlocs(i).labels, resultEEG.chanlocs(i).labels));
%end

%% Test 2: One montage order
targetOrder = {'Fp1', 'Fp2', 'F3', 'F4', 'F7', 'F8', ...
                'T3', 'T4', 'T5', 'T6', ...
                'C3', 'C4', 'P3', 'P4', 'O1', 'O2', ...                 
                'A1', 'A2', 'Fz', 'Cz', ...
                'Pz', 'Fpz', 'EKG', 'Photic'};
resultEEG = ScoreOrderChannels(EEG, targetOrder);
for i=1:size(EEG.chanlocs,2)
    assert(strcmp(resultEEG.chanlocs(i).labels, targetOrder{i}),['EEG ' resultEEG.chanlocs(i).labels ' ~= targetOrder ' targetOrder{i}]);
end