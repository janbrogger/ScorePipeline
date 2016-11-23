%Updates the file existing status for one SearchResult_Recording
%and if file does not exist and the workflow state is "not started"
%then we set the workflow state to -1, "invalid"
function ScoreCheckOneRecordingFile(searchResultRecordingId)
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
  else  
      fullPath = strcat(recording(4), '\', recording(3));
      if not(exist(fullPath{1}, 'file') == 2)
          ScoreSetRecordingFileStatus(searchResultRecordingId, -1);
          ScoreSetWorkStatus(searchResultRecordingId, -1, 2);
      else
          ScoreSetRecordingFileStatus(searchResultRecordingId, 1);          
      end  
   end
end