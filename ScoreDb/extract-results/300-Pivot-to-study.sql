USE HolbergAnon2
IF OBJECT_ID('tempdb..PivotStudy') IS NOT NULL DROP TABLE tempdb..PivotStudy
IF OBJECT_ID('tempdb..##KeepColumns') IS NOT NULL DROP TABLE ##KeepColumns
--SELECT * FROM ##PivotResult6

SELECT name INTO ##KeepColumns FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult6') AND 
	(
		(name LIKE 'SearchResultId') OR
		(name LIKE 'SearchResultComment') OR
		(name LIKE 'Patient%') OR
		(name LIKE 'Study%') OR
		(name LIKE 'IndicationForEEG%') OR
		(name LIKE 'Referrer%') OR
		(name LIKE 'Medication%') OR
		(name LIKE 'Diagnose%') OR
		(name LIKE 'Description%') OR 
		(name LIKE 'IsDescription%') OR 
		(name LIKE 'IsSigned%') OR 
		(name LIKE 'Report%') OR 
		(name LIKE 'Recording%')
	)
	ORDER BY column_id
DECLARE @KeepColumns AS VARCHAR(MAX)
SELECT @KeepColumns= COALESCE(@KeepColumns + ',' + name,name) FROM ##KeepColumns
PRINT  @KeepColumns



DECLARE @PivotSql AS VARCHAR(MAX)
SET @PivotSql = 
	'SELECT  DISTINCT '+	
	@KeepColumns+
	' INTO tempdb..PivotStudy '+
	' FROM tempdb..PivotResult6'+
	' ORDER BY SearchResultId, StudyId'
PRINT @PivotSql
EXEC(@PivotSql)

SELECT COUNT(*) FROM tempdb..PivotStudy 
SELECT COUNT(*) FROM SearchResult_Study

SELECT * FROM tempdb..PivotStudy 