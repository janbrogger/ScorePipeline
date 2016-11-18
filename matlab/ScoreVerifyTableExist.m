
function [tableExists] = ScoreVerifyTableExist(tableName)    
    tableExists = ScoreTableExist(tableName);
    if not(tableExists)
        error(['The ' tableName ' table does not exist in the SCOREAnon database. ']);
    else
        disp(['The ' tableName ' table exists in the SCOREAnon database']);
    end    
end