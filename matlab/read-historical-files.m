eegDir = 'J:\2016\Eeglab-nervus\history\';
eeglist = struct();
eegdirlist = dir(eegDir);
j = 1;
for i=3:size(eegdirlist,1)        
     if eegdirlist(i).isdir   
         eegdirlist2 = dir([eegDir eegdirlist(i).name '\*.e*']);  
         for k=1:size(eegdirlist2,1)    
             oneeeg = [eegDir eegdirlist(i).name '\' eegdirlist2(k).name];
             disp(oneeeg);
             eeglist(j).filename = oneeeg;
             eeglist(j).opensuccess = -1;
             j = j + 1;
         end        
     end
end

j = 1;
for i=1:size(eeglist,2)    
    disp([num2str(j) ' ' datestr(now) ' ' eeglist(i).filename]);
    try        
        ft_read_header(eeglist(i).filename);
        ft_read_data(eeglist(i).filename);
        eeglist(i).opensuccess = 1;
    catch
        eeglist(i).opensuccess = 0;
    end     
    j = j+1;
    k = waitforbuttonpress 
end

struct2table(eeglist);
