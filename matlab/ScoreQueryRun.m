function [data] = ScoreQueryRun(sqlquery)
    timer = tic;
    conn = ScoreDbConnGet();

    curs = exec(conn, sqlquery);
    curs = fetch(curs);
    data = curs.Data;
    close(curs);
    timeElapsed = toc(timer);
    ScoreDebugLog(['ScoreQueryRun took ' num2str(timeElapsed) ' seconds']);
end