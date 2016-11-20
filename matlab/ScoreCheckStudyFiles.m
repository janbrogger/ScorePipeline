function recordings = ScoreCheckStudyFiles(searchResultId)
    query = ['SELECT SearchResultStudyId FROM SearchResult_Study ' ... 
        'WHERE SearchResultId = ' num2str(searchResultId) ]; 
  
  recordings = ScoreQueryRun(query);  
  count = size(recordings, 1);
  for i=1:count
      recording = recordings(i);      
      ScoreCheckOneStudyFiles(recording{1});
  end  
end