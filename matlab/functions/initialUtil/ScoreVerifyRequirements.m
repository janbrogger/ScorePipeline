function ScoreVerifyRequirements()    
    
    %Test the connection to the SCORE anonymized database that we need
    ScoreVerifyConnection();
    ScoreVerifyTableExist('SearchResult');
    ScoreVerifyTableExist('SearchResult_Study');    
    ScoreVerifyTableExist('SearchResult_Description');    
    ScoreVerifyTableExist('SearchResult_Recording');    
    ScoreVerifyTableExist('SearchResult_EventCoding');    
    ScoreVerifyTableExist('SearchResult_Event');    
    ScoreVerifyTableExist('SearchResult_Event_Annotation');    
    ScoreVerifyTableExist('SearchResult_Event_UserWorkstate');    
    ScoreVerifyTableExist('SearchResult_AnnotationConfig');     
    ScoreVerifyEeglab();
end