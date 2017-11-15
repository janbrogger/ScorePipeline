function [data] = ScoreQueryRun(sqlquery)
    timer = tic;
    conn = ScoreDbConnGet();

    curs = exec(conn, sqlquery);
    curs = fetch(curs);
    
    
    if startsWith(sqlquery,'UPDATE')  || startsWith(sqlquery,'INSERT') 
        if ~strcmp(curs.Message, 'Invalid Result Set') && ~isempty(curs.Message) 
            error(['ScoreQueryRun error - message from database :' curs.Message]);
        end
    else
        if ~isempty(curs.Message) 
            error(['ScoreQueryRun error - message from database :' curs.Message]);
        end
    end
        
    data = curs.Data;
    close(curs);
    timeElapsed = toc(timer);
    ScoreDebugLog(['ScoreQueryRun took ' num2str(timeElapsed) ' seconds']);
end