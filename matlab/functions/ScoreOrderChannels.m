function EEG = ScoreOrderChannels(EEG, montageOrder)

    for i=1:size(montageOrder, 2)
        disp(['Channel list at step ' num2str(i) ' is: ' EEG.chanlocs.labels]);
        index1 = find(cellfun(@(x) strcmp(x, montageOrder{i}), {EEG.chanlocs.labels}));                
        if ~isempty(index1) && index1 ~= i             
            row1 = EEG.data(index1,:);
            row2 = EEG.data(i,:);
            chaninfo1 = EEG.chanlocs(index1,:);
            chaninfo2 = EEG.chanlocs(i,:);
            disp(['Swapping channels ' EEG.chanlocs(index1).labels ' and ' EEG.chanlocs(i).labels]);

            EEG.data(index1,:) = row2;
            EEG.data(i,:) = row1;            

            EEG.chanlocs(index1) = chaninfo2;
            EEG.chanlocs(i) = chaninfo1;            
            
        end
    end
end