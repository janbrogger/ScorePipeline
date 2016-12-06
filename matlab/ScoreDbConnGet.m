function [conn] = ScoreDbConnGet
    timer = tic;
    
    if ScoreSession.setdbprefs == 0        
        setdbprefs('DataReturnFormat','cellarray');
        ScoreDebugLog(['ScoreDbConnGet called  setdbprefs']);    
        ScoreSession.setdbprefs = 1;
    end
    if isempty(ScoreSession.setgetODBC())
        conn = database.ODBCConnection(ScoreConfig.odbcDatabaseName, '', '');
        ScoreDebugLog(['ScoreDbConnGet got a new connection']);    
        ScoreSession.setgetODBC(conn);
    else
        conn = ScoreSession.setgetODBC();
        ScoreDebugLog(['ScoreDbConnGet used an existing connection']);    
    end
    timeElapsed = toc(timer);
    ScoreDebugLog(['ScoreDbConnGet took ' num2str(timeElapsed) ' seconds']);    
end