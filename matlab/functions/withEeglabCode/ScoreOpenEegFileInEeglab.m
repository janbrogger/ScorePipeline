function openSuccess = ScoreOpenEegFileInEeglab(newFilePath, searchResultEventId)
    disp(['Opening new EEG file ' newFilePath ' SearchResultEventId: ' searchResultEventId] );    
    openSuccess = 0;
    %Start up EEGLAB if pop_fileio is not in the path   
    if not(exist('pop_fileio', 'file'))
        eeglab
    end
    %Close any existing plot
    existingPlot = findobj(0, 'tag', 'EEGPLOT');
    
    if size(existingPlot,1) == 1
        close(existingPlot.Number)
    elseif size(existingPlot,1) > 1
        for i = 1:size(existingPlot,1)    
            close(existingPlot(i).Number)
        end
    end
    
    if not(exist(newFilePath, 'file'))
       ScoreClearEeglabStudy()
    else        
        try 
            EEG = pop_fileio(newFilePath);                
            EEG.setname='test';    
            
            
            EEG = pop_select( EEG,'nochannel',{'Rate' 'IBI' 'Bursts' 'Suppr'});    
                                   
            %Remove unused channels            
            exclIndex1 = find(strcmp({EEG.chanlocs(:).labels}, '24'));
            exclIndex2 = find(strcmp({EEG.chanlocs(:).labels}, '25'));
            exclIndex3 = find(strcmp({EEG.chanlocs(:).labels}, '26'));
            exclIndex4 = find(strcmp({EEG.chanlocs(:).labels}, '27'));
            exclIndex5 = find(strcmp({EEG.chanlocs(:).labels}, '28'));
            exclIndex6 = find(strcmp({EEG.chanlocs(:).labels}, '29'));
            exclIndex7 = find(strcmp({EEG.chanlocs(:).labels}, '30'));
            exclIndex8 = find(strcmp({EEG.chanlocs(:).labels}, '31'));
            EEG = pop_select( EEG,'nochannel',[exclIndex1  exclIndex2  exclIndex3  exclIndex4  exclIndex5  exclIndex6  exclIndex7  exclIndex8 ]);
            EEG = eeg_checkset( EEG );

            ekgindex = find(strcmp({EEG.chanlocs(:).labels}, 'EKG'));
            photicindex = find(strcmp({EEG.chanlocs(:).labels}, 'Photic'));
            
            EEG = pop_reref( EEG, [],'exclude',[ekgindex photicindex ]);  
            %notch
            EEG = pop_eegfiltnew(EEG, 48, 52, 3300, 1, [], 0);
            %passband
            EEG = pop_eegfiltnew(EEG, 1, 70, 6600, 0, [], 0);

            EEG = SetSomeLongEventsToZero(EEG);
            EEG = InsertSomeEventNames(EEG);
            
            %Downscale EKG
            EEG.data(ekgindex,:) = EEG.data(ekgindex,:)/5;
                                   
            eegplot( EEG.data, ...
                'winlength', 10,  ...
                'selectcommand', {1,1,1}, ...
                'srate', EEG.srate, ...
                'title', 'EEG plot', ...
                'command' , 'disp(''mouse event lead to command'');' , ...
                'events', EEG.event, ...
                'limits', [EEG.xmin EEG.xmax]*1000, ...
                'eloc_file', EEG.chanlocs, ...
                'scale', 'off', ...
                'selectcommand', {'ScoreMouseDown();', 'ScoreMouseMove();', 'ScoreMouseUp();'}, ...
                'ctrlselectcommand', {'disp(''ctrlmousedown'');', '', 'disp(''ctrlmouseup'');'} ...
                );                                
                        
            ScoreInsertScaleEyes();
            clear ekgindex
            EEG.filename = ['searchResultEventId = ' num2str(searchResultEventId)];
            assignin('base','EEG',EEG);
            eeg_checkset( EEG );                          
            
            evalin('base', 'eeglab redraw');
            figh = ScoreGetEeglabPlot(0);
            set(figh, 'windowbuttonmotionfcn', {@ScoreMouseMove});
            
            openSuccess = 1;
        catch
            ScoreClearEeglabStudy()
        end
    end
end

function ScoreClearEeglabStudy()
        assignin('base','STUDY', []); 
        assignin('base','CURRENTSTUDY', 0); 
        assignin('base','ALLEEG', []); 
        assignin('base','EEG', []); 
        assignin('base','CURRENTSET', []);  
end

function EEG = SetSomeLongEventsToZero(EEG)
        eventsToChangeDuration = find(strcmp({EEG.event(:).value},'Review progress'));
        for i = eventsToChangeDuration
            EEG.event(i).duration = 0;
        end
end

function EEG = InsertSomeEventNames(EEG)
    for i=1:size(EEG.event,2)
        for j=1:size(ScoreConfig.eventGuids)  
            if length(EEG.event(i).type) >= 36
                if strcmp(EEG.event(i).type(1:36), ScoreConfig.eventGuids(j,1))
                    EEG.event(i).value = ScoreConfig.eventGuids{j,2};
                    EEG.event(i).type = ScoreConfig.eventGuids{j,2};
                end                
            end
        end
    end
end