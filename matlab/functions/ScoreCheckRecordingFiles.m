function recordings = ScoreCheckRecordingFiles(searchResultId)
    query = ['SELECT SearchResultRecordingId FROM SearchResult_Recording ' ... 
        'WHERE SearchResultId = ' num2str(searchResultId) ]; 
  
  recordings = ScoreQueryRun(query);  
  count = size(recordings, 1);
  for i=1:count
      recording = recordings.SearchResultRecordingId(i);
      ScoreCheckOneRecordingFile(recording);
  end  
end