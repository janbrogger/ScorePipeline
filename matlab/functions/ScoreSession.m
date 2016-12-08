classdef ScoreSession        
  methods (Static)
      function out = setgetDatabaseConnection(data)
         persistent databaseConnection;
         if nargin
            databaseConnection = data;
         end
         out = databaseConnection;
      end
      
      function out = setgetDbPrefs(data)
         persistent dbprefs;
         if nargin
            dbprefs = data;
         else
             dbprefs = -1;
         end
         out = dbprefs;
      end  
      
      
   
      function CloseDB()
        if isempty(ScoreSession.setgetDatabaseConnection())                
            ScoreDebugLog('ScoreSession.CloseDB() - no open connection - nothing to do');
        else
            conn = ScoreSession.setgetDatabaseConnection();
            close(conn);
            ScoreDebugLog('ScoreSession.CloseDB() - the open connection was closed');    
        end
      end
  end  
end