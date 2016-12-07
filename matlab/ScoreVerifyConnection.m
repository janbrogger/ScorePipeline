
function ScoreVerifyConnection()    
    conn = ScoreDbConnGet();
    if (not(isempty(conn.Message)))
        if strcmp(conn.Message,'Unable to find JDBC driver.')            
            disp('Error on connecting to SCORE database - trying to do some setup');
            ScoreAssistJDBC();
            disp('****Try the following command to debug:***');
            disp(['database(''' ScoreConfig.databaseName ''', ' ...
                    ''''', '''', ' ...
                    '''Vendor'', ''Microsoft SQL Server'',' ...
                    '''Server'', ''' ScoreConfig.databaseServer ''', ' ...
                    '''AuthType'', ''Windows'',' ...
                    '''PortNumber'', 1433)']);
            error('Error on connecting to SCORE database - tried JDBC assist, restart Matlab');            
        else
            error(['Error on connecting to SCORE database - other error:'  conn.Message]);
        end
    else
        disp('SCORE database connection successful');
    end
end