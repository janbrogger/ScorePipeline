function [data] = ScoreQueryRun(sqlquery)
    conn = ScoreDbConnGet();

    curs = exec(conn, sqlquery);
    curs = fetch(curs);
    data = curs.Data;
    close(curs);
    close(conn);
end