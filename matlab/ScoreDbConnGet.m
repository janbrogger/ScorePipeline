function [conn] = ScoreDbConnGet
    setdbprefs('DataReturnFormat','cellarray')
    conn = database.ODBCConnection(ScoreConfig.odbcDatabaseName, '', '');
end