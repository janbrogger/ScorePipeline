function ScoreVerifyRequirements()    
    
    %Test the ODBC connection to the SCORE anonymized database that we need
    ScoreVerifyConnection();
    ScoreVerifyTableExist('SearchResult');
    ScoreVerifyTableExist('SearchResult_Study');    
    ScoreVerifyEeglab();
end