
function ScoreVerifyConnection()    
    conn = ScoreDbConnGet();
    if (not(isempty(conn.Message)))
        error('Error on connecting to SCORE database using ODBC');
    else
        disp('SCORE database connection successful');
    end
end