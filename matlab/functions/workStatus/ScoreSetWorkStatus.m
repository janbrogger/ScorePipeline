function ScoreSetWorkStatus(primaryKey, workStatusValue, objectType)    

    switch objectType
        case 0 %Study
            table = 'Study';
        case 1 %Description
            table = 'Description';
        case 2 %Recording
            table = 'Recording';
        case 3 %EventCoding
            table = 'EventCoding';
        case 4 %Event
            table = 'event';
        otherwise
            error('Unknown type of object to count');
    end    
    query = ['UPDATE [dbo].[SearchResult_' table '] SET WorkflowState = ' ...
          num2str(workStatusValue) ...
          ' WHERE SearchResult' table 'Id = ' ...
          num2str(primaryKey)]; 
  
  ScoreQueryRun(query);  
end