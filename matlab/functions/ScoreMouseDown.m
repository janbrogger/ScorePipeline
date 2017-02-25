function data = ScoreMouseDown(varargin)
    data = [];
    g = get(gcf,'UserData');
    cp = get(gca,'currentpoint');
    
    clickedTime = g.time+cp(1)/g.srate;
    clickedSample = round(g.time*g.srate+cp(1),0);
    
    clickedYValue = cp(1,2);
    
    EEG = evalin('base','EEG');
    thisColumnOfData = EEG.data(:,clickedSample);    
    %disp('This column of data:');
    %fprintf(' %2.3f\n', thisColumnOfData')
    
    g = get(gcf,'UserData');
    %disp(['spacing ' num2str(g.spacing)]);
    
    for i=1:size(thisColumnOfData, 1)
        thisColumnOfDataWithSpacing(i) = EEG.data(i,clickedSample)+g.spacing*(1+size(thisColumnOfData, 1)-i);
    end
    %disp('This column of data with spacing:');
    %fprintf(' %2.3f\n', thisColumnOfDataWithSpacing');
    
    diffThisColumnOfDataWithSpacing = thisColumnOfDataWithSpacing-clickedYValue;
    %disp('This column of data with diff of clickedYValue:');
    %fprintf(' %2.3f\n', diffThisColumnOfDataWithSpacing')
    [diffValue,indexOfClosestMatch] = min(abs(diffThisColumnOfDataWithSpacing));
    selectedChannel = EEG.chanlocs(indexOfClosestMatch);
    
    disp(['Clicked elapsed time : ' num2str(clickedTime)]);  
    disp(['Clicked sample : ' num2str(clickedSample)]);  
    disp(['Current time position at left is ' num2str(g.time)]);
    disp(['Current time position at right is ' num2str(g.time+g.winlength*g.srate)]);
    disp(['Clicked voltage: ' num2str(clickedYValue)]);      
    disp([' Selected channel ' selectedChannel.labels ' ,closest EEG value ' num2str(EEG.data(indexOfClosestMatch,clickedSample)) ]);    
end