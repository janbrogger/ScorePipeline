function [clickedTime, clickedSample, selectedChannelIndex, clickedEegValue] = ScoreGetClickedTraceFromPoint(point)    
    g = get(gcf,'UserData');
        
    clickedTime = g.time+point(1)/g.srate;
    clickedSample = round(g.time*g.srate+point(1),0);
    
    clickedYValue = point(1,2);
    
    EEG = evalin('base','EEG');
    thisColumnOfData = EEG.data(:,clickedSample);    
    
    g = get(gcf,'UserData');        
    for i=1:size(thisColumnOfData, 1)
        thisColumnOfDataWithSpacing(i) = EEG.data(i,clickedSample)+g.spacing*(1+size(thisColumnOfData, 1)-i);
    end    
    
    diffThisColumnOfDataWithSpacing = thisColumnOfDataWithSpacing-clickedYValue;    
    [diffValue,indexOfClosestMatch] = min(abs(diffThisColumnOfDataWithSpacing));
    selectedChannel = EEG.chanlocs(indexOfClosestMatch);
    
    selectedChannelIndex = indexOfClosestMatch;
    clickedEegValue = EEG.data(indexOfClosestMatch,clickedSample);
        
    %disp(['Clicked elapsed time : ' num2str(clickedTime)]);  
    %disp(['Clicked sample : ' num2str(clickedSample)]);  
    %disp(['Current time position at left is ' num2str(g.time)]);
    %disp(['Current time position at right is ' num2str(g.time+g.winlength*g.srate)]);
    %disp(['Clicked voltage: ' num2str(clickedYValue)]);      
    %disp([' Selected channel ' selectedChannel.labels ' ,closest EEG value ' num2str(EEG.data(indexOfClosestMatch,clickedSample)) ]);    
    
    
end