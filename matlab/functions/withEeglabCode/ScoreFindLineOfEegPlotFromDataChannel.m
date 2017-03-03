function [matchline, nomatchlines] = ScoreFindLineOfEegPlotFromDataChannel(currentChannelIndex, eegaxis)

    matchline = [];
    nomatchlines = gobjects(0);
    lines = findobj('type', 'Line', 'parent', eegaxis);
    actualIndex = 0;
    maxXDataSize = 0;
    for i = 1:size(lines, 1)
        if size(lines(i).XData,2) > maxXDataSize
            maxXDataSize = size(lines(i).XData,2);                
        end
    end
    for i = 1:size(lines, 1)
        if  ~strcmp(get(lines(i),'tag'),'vlineindicator') ...
                && ~strcmp(get(lines(i),'tag'),'selectindicator') 
            if  size(lines(i).XData,2)==maxXDataSize
                actualIndex = actualIndex+1;
                if actualIndex == currentChannelIndex
                    matchline = lines(i);                    
                else             
                    newsize = size(nomatchlines,2)+1;
                    nomatchlines(newsize) = lines(i);
                end                        
            end
        end
    end    
end        