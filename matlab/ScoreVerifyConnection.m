
function ScoreVerifyConnection()    
    conn = ScoreDbConnGet();
    if (not(isempty(conn.Message)))
        if strcmp(conn.Message,'Unable to find JDBC driver.')            
            disp('Error on connecting to SCORE database - trying to do some setup');
            ScoreAssistJDBC();
            error('Error on connecting to SCORE database - tried JDBC assist, restart Matlab');
        else
            error(['Error on connecting to SCORE database - other error:'  conn.Message]);
        end
    else
        disp('SCORE database connection successful');
    end
end