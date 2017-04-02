function EEG = ScoreOrderChannels(EEG, montageOrder)

    disp(['Target order is:         '  char(10) sprintf(' %3s',montageOrder{:})]);
    disp(['Channel list at start is:'  char(10) sprintf(' %3s',EEG.chanlocs.labels)]);
    currentPosition = 0;
    for i=1:size(montageOrder, 2)
        %disp(['Channel list at step ' num2str(i) ' is:' char(10) sprintf(' %3s',EEG.chanlocs.labels)]);
        index1 = find(cellfun(@(x) strcmp(x, montageOrder{i}), {EEG.chanlocs.labels}));                
        if ~isempty(index1) && i <= size(EEG.chanlocs,2)
            currentPosition = currentPosition+1;
            row1 = EEG.data(index1,:);
            row2 = EEG.data(currentPosition,:);
            chaninfo1 = EEG.chanlocs(index1);
            chaninfo2 = EEG.chanlocs(currentPosition);
            %disp(['Swapping channels ' EEG.chanlocs(index1).labels ' and ' EEG.chanlocs(currentPosition).labels]);

            EEG.data(index1,:) = row2;
            EEG.data(currentPosition, :) = row1;
            EEG.chanlocs(index1) = chaninfo2;
            EEG.chanlocs(currentPosition) = chaninfo1;            
            
        end
    end
    disp(['Channel list at end is:' char(10) sprintf(' %3s',EEG.chanlocs.labels)]);
end