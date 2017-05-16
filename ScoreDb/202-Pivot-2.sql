----------------------------
USE HolbergAnon
--Drop some temp tables
IF OBJECT_ID('tempdb..##PivotResult2') IS NOT NULL DROP TABLE ##PivotResult2
IF OBJECT_ID('tempdb..#AnnotationUsers') IS NOT NULL DROP TABLE #AnnotationUsers
IF OBJECT_ID('tempdb..#AnnotationFields') IS NOT NULL DROP TABLE #AnnotationFields
IF OBJECT_ID('tempdb..#AnnotationsAndUsers') IS NOT NULL DROP TABLE #AnnotationsAndUsers
GO





--Now pivot a second time 
--Store users who did annotations
SELECT * INTO #AnnotationUsers FROM [User] 	WHERE [User].UserName='jcbr' OR [User].UserName='eivaan'
SELECT * FROM #AnnotationUsers
--Store fieldnames for annotations
SELECT DISTINCT FieldName INTO #AnnotationFields FROM SearchResult_AnnotationConfig
SELECT * FROM #AnnotationFields
--Now make columns names for each annotation that includes userid
SELECT FieldName, 
       #AnnotationUsers.UserId, 
	   CONCAT(FieldName,'_',#AnnotationUsers.UserId ) AS ColumnName, 
	   ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS RowNumber,
	   CONCAT('U', ROW_NUMBER() OVER(ORDER BY (SELECT 0))) AS UserIdMultiplexed
	INTO #AnnotationsAndUsers 
	FROM #AnnotationFields
	CROSS JOIN #AnnotationUsers 
	ORDER BY FieldName
SELECT * FROM #AnnotationsAndUsers
	

DECLARE @AnnotationList1 AS VARCHAR(MAX)
SELECT @AnnotationList1 = COALESCE(@AnnotationList1 + ',' + FieldName + '',  '' + FieldName+ '')   FROM (SELECT DISTINCT FieldName FROM SearchResult_AnnotationConfig) AS x
PRINT @AnnotationList1

DECLARE @AnnotationUserCount AS int
SELECT @AnnotationUserCount = COUNT(*) FROM #AnnotationsAndUsers
PRINT @AnnotationUserCount

--Generate a pivoted columns list
DECLARE @cnt INT = 0;
WHILE @cnt < @AnnotationUserCount
BEGIN
   --SELECT 'MAX('
   --PRINT 'PIVOT(MIN('
   SET @cnt = @cnt + 1;
END;;

DECLARE @UserIds1 AS VARCHAR(MAX)
SELECT @UserIds1 = COALESCE(@UserIds1 + ',[P' + CAST(UserId as varchar) + ']',  '[P' + cast(UserId as varchar)+ ']')   FROM #AnnotationUsers

DECLARE @UserIds2 AS VARCHAR(MAX)
SELECT @UserIds2 = COALESCE(@UserIds2 + ',[U' + CAST(UserId as varchar) + ']',  '[U' + cast(UserId as varchar)+ ']')   FROM #AnnotationUsers



DECLARE @PivotSql2 AS VARCHAR(MAX)
SET @PivotSql2 = 
	N'SELECT  '+	
	N'EventId, '+
	N'MAX([P2]) AS SpikeStartSample_2, ' +
	N'MAX([P25]) AS SpikeStartSample_25, ' +
	N'MAX([U2]) AS SpikeEndSample_2, ' +
	N'MAX([U25]) AS SpikeEndSample_25 ' +
	N' INTO ##PivotResult2 ' +
	N' FROM (SELECT EventId, CONCAT(''P'',UserId) AS UserId1, CONCAT(''U'',UserId) AS UserId2, '+@AnnotationList1+' FROM ##PivotResult) AS src '+
	N' PIVOT('+
    N'  MIN(SpikeStartSample)'+
	N'  FOR UserId1'+
    N'  IN ('+ @UserIds1 +')'+
	N') AS piv1 ' +
	N' PIVOT('+
    N'  MIN(SpikeEndSample)'+
	N'  FOR UserId2'+
    N'  IN ('+ @UserIds2 +')'+
	N') AS piv2 ' +
	N' GROUP BY EventId '
PRINT @PivotSql2
EXEC(@PivotSql2)
SELECT * FROM ##PivotResult2