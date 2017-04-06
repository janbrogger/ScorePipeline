function ScoreSetUserAnnotationWorkStatus(searchResultEventId, userId, value)    

    
    existingQuery = ['SELECT ' ...
      '[SearchResultEventId] ' ...
      ',[UserId] ' ...
      ',[Workstate] ' ...
      'FROM SearchResult_Event_UserWorkstate ' ...
      'WHERE SearchResultEventId=' num2str(searchResultEventId) ...
      ' AND UserId=' num2str(userId) ...
      ];
  existingData = ScoreQueryRun(existingQuery);
  
  if strcmp(existingData, 'No Data')
      insertQuery = [
    'INSERT INTO [dbo].[SearchResult_Event_UserWorkstate] ' ...
    '           ([SearchResultEventId] ' ...
    '           ,[UserId] ' ...
    '           ,[Workstate]) ' ...
    '     VALUES ' ...
    '           (' num2str(searchResultEventId) ' ' ...
    '           ,' num2str(userId) ' ' ...
    '           ,' num2str(value)  ') ' ...;

          ];
      ScoreQueryRun(insertQuery);
  else
    updateQuery = [
    'UPDATE [dbo].[SearchResult_Event_UserWorkstate] ' ...
    'SET [Workstate] = ' num2str(value) ' ' ...
    'WHERE SearchResultEventId=' num2str(searchResultEventId) ...
      ' AND UserId=' num2str(userId) ...
        ]; 
      ScoreQueryRun(updateQuery);  
  end
  
end