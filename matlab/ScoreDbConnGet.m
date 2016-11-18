function [conn] = ScoreDbConnGet
    conn = database.ODBCConnection('SCOREAnon', '', '');
end