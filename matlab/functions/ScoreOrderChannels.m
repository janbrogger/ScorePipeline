function EEG = ScoreOrderChannels(EEG, montageOrder)

    for i=1:size(montageOrder, 2)
        index = find(cellfun(@(x) strcmp(x, montageOrder{i}), {EEG.chanlocs.labels}));
        if ~isempty(index)
            row1 = EEG.data(index,:);
            row2 = EEG.data(i,:);
            chaninfo1 = EEG.chaninfo(index,:);
            chaninfo2 = EEG.chaninfo(i,:);
            
            EEG.data(i) = row1;
            EEG.data(index) = row2;
            
            EEG.chaninfo(index) = chaninfo2;
            EEG.chaninfo(i) = chaninfo1;
            
        end
    end
end