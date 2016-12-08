
function [tableExists] = ScoreTableExist(tableName)
    query = ScoreQueryRun(['SELECT OBJECT_ID(N''dbo.'  tableName  ''', N''U'')']);
    tableExists = not(cellfun(@isnan, query));
end