scoreData = SetupScoreExtractDb('J:\ScorePipeline\');
scoreData.FileIndex = zeros(size(scoreData.FilePath,1),1);
scoreData.FilePath2 = cell(size(scoreData.FilePath,1),1);

disp('Extracting file index number...');
%Extract file index
for i=1:1:size(scoreData.FilePath)    
    scoreData.FilePath(i) = strrep(scoreData.FilePath(i),'\\batman.knf.local\','\\hbemta-nevrofil01.knf.local\');    
    fileIndexCell = regexp(scoreData.FilePath(i),'\\([0-9][0-9][0-9][0-9][0-9])$','tokens');
    if ~isempty(fileIndexCell{1})
        scoreData.FileIndex(i)= cellfun(@str2num,fileIndexCell{1}{1});
    end
end

disp('Setting new file path..');
%Set file paths to local new paths
for i=1:1:size(scoreData.FilePath,1)        
    %filePath2 = '';
    if (scoreData.FileIndex(i) >= 60001) 
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 55001) &&  (scoreData.FileIndex(i) <= 660000)
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\55001-60000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 50001) &&  (scoreData.FileIndex(i) <= 55000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\50001-55000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 45001) &&  (scoreData.FileIndex(i) <= 55000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\45001-50000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 40001) &&  (scoreData.FileIndex(i) <= 45000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\40001-45000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 35001) &&  (scoreData.FileIndex(i) <= 40000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\35001-40000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 30001) &&  (scoreData.FileIndex(i) <= 35000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\30001-35000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 25001) &&  (scoreData.FileIndex(i) <= 30000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\25001-30000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 20001) &&  (scoreData.FileIndex(i) <= 25000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\20001-25000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 15001) &&  (scoreData.FileIndex(i) <= 20000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\15001-20000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 10001) &&  (scoreData.FileIndex(i) <= 15000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\10001-15000\', num2str(scoreData.FileIndex(i)));
    elseif (scoreData.FileIndex(i) >= 0) &&  (scoreData.FileIndex(i) <= 10000)        
         filePath2 = strcat('\\hbemta-nevrofil01.knf.local\Rutine\workarea\0-10000\', num2str(scoreData.FileIndex(i)));
    end
    %disp(filePath2);
    scoreData.FilePath2{i} = filePath2;
end

%Make full path
disp('Setting new full path..');
scoreData.FilePathAndName = cell(size(scoreData.FilePath,1),1);
for i=1:1:size(scoreData.FilePath)    
    scoreData.FilePathAndName{i} = strcat(scoreData.FilePath2{i}, '\', scoreData.FileName{i});
end


%Check file exists
disp('Checking file exists..');
scoreData.FileExist = zeros(size(scoreData.FilePath,1),1);
for i=1:1:size(scoreData.FilePath)        
    if mod(i,1000)==0
        disp(i);
    end
    scoreData.FileExist(i) = exist(scoreData.FilePathAndName{i},'file') == 2;
end
totalFileCount = size(scoreData.FilePath,1);
missingFileCount = sum(scoreData.FileExist==0);
foundFileCount = sum(scoreData.FileExist);
disp(['Checked ' num2str(totalFileCount) ' files. Found ' num2str(foundFileCount),' files. '  num2str(missingFileCount) ' files not found']);


