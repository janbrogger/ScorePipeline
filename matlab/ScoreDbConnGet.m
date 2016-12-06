function [conn] = ScoreDbConnGet
    timer = tic;
    
    scoreSession = ScoreSession();
    
    if scoreSession.setgetDbPrefs() == 0        
        setdbprefs('DataReturnFormat','cellarray');
        ScoreDebugLog(['ScoreDbConnGet called  setdbprefs']);    
        scoreSession.setdbprefs = 1;
    end
    
    conn = database(ScoreConfig.databaseName, ...
        '','', ...
        'Vendor','Microsoft SQL Server', ...
        'Server',ScoreConfig.databaseServer, ...
        'AuthType','Windows', ...
        'PortNumber',1433);
                
    timeElapsed = toc(timer);
    ScoreDebugLog(['ScoreDbConnGet took ' num2str(timeElapsed) ' seconds']);    
end