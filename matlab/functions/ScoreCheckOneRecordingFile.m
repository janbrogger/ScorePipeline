%Updates the file existing status for one SearchResult_Recording
%and if file does not exist and the workflow state is "not started"
%then we set the workflow state to -1, "invalid"
function [result, fullPath] = ScoreCheckOneRecordingFile(searchResultRecordingId)
    result = -1;
    query = ['SELECT  SearchResult_Recording.RecordingId' ...      
      ' , WorkflowState' ...
      ' ,CONVERT(varchar(255), FileName) AS FileName2' ...
      ' ,CONVERT(varchar(255), FilePath) AS FilePath2' ...      
      ' FROM SearchResult_Recording ' ...
      ' INNER JOIN Recording ON SearchResult_Recording.RecordingId = Recording.RecordingId' ...
      ' WHERE SearchResult_Recording.SearchResultRecordingId = ' ...
      num2str(searchResultRecordingId) ]; 
  
  recording = ScoreQueryRun(query);      
  if strcmp(recording, 'No Data')
      ScoreSetRecordingFileStatus(searchResultRecordingId, -1);
      ScoreSetWorkStatus(searchResultRecordingId, -1, 2);
      result = -1;
  else  
      try 
          fullPath = strcat(recording.FilePath2{1},  recording.FileName2{1});
          fullPath = strrep(fullPath, '\\', '\');
          if not(exist(fullPath, 'file') == 2)
              ScoreSetRecordingFileStatus(searchResultRecordingId, -1);
              ScoreSetWorkStatus(searchResultRecordingId, -1, 2);
              result = -1;
          else
              ScoreSetRecordingFileStatus(searchResultRecordingId, 1);          
              result = 1;
          end 
      catch 
          ScoreSetRecordingFileStatus(searchResultRecordingId, -1);          
          result = -1;
      end
   end
end