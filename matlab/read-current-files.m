
% reads in approx 5000 file names from a portion of the archive
eegDir = '\\hbemta-nevrofil01.knf.local\RutineArkiv1\40001-45000\';
eeglist = struct();
eegdirlist = dir(eegDir);
j = 1;
for i=3:size(eegdirlist,1)        
     if eegdirlist(i).isdir   
         eegdirlist2 = dir([eegDir eegdirlist(i).name '\*.e*']);  
         for k=1:size(eegdirlist2,1)    
             oneeeg = [eegDir eegdirlist(i).name '\' eegdirlist2(k).name];
             %disp(oneeeg);
             eeglist(j).filename = oneeeg;
             eeglist(j).opensuccess = -1;
             j = j + 1;
         end        
     end
end

%then extract around 100 files of that list
eegcount = size(eeglist,2);
extractsize = 99;
eeglist = eeglist([eegcount-extractsize:eegcount]);


j = 1;
for i=1:size(eeglist,2)   
    tic
    disp([num2str(j) ' ' datestr(now) ' ' eeglist(i).filename]);
    try        
        ft_read_header(eeglist(i).filename);
        %ft_read_data(eeglist(i).filename);
        eeglist(i).opensuccess = 1;
    catch ex
        disp(['Exception: ' ex.identifier])
        eeglist(i).opensuccess = 0;
    end     
    j = j+1;    
    eeglist(i).elapsed = toc;
end

struct2table(eeglist);
sum(cat(1,eeglist.opensuccess))
size(eeglist,2)