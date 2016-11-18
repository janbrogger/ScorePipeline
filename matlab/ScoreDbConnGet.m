function [conn] = ScoreDbConnGet
    setdbprefs('DataReturnFormat','cellarray')
    conn = database.ODBCConnection('SCOREAnon', '', '');
end