
function [tableExists] = ScoreTableExist(tableName)
    query = ScoreQueryRun(['SELECT OBJECT_ID(N''dbo.'  tableName  ''', N''U'')']);
    tableExists = not(isnan(query{1,1}));
end