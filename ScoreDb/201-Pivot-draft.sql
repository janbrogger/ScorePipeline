USE HolbergAnon
IF OBJECT_ID('tempdb..#PivotBase') IS NOT NULL DROP TABLE #PivotBase
IF OBJECT_ID('tempdb..#PivotBase2') IS NOT NULL DROP TABLE #PivotBase2
GO
SELECT        
 --SearchResult.SearchResultId,
 --SearchResult.Comment AS SearchResultComment,
 --SearchResult_Event.SearchResultEventId,
 Event.EventId,
 --Event.StartDateTime AS EventStart,
 --Event.EndDateTime AS EventStop,
 --Event.Duration AS EventDuration,
 --SearchResult_Event_Annotation.SearchResultEventAnnotationId,
 --SearchResult_Event_UserWorkstate.Workstate AS AnnotationUserWorkState, 
 --SearchResult_AnnotationConfig.SearchResultAnnotationConfigId,
 SearchResult_AnnotationConfig.FieldName AS AnnotationFieldName,
 --SearchResult_AnnotationConfig.HasInteger, 
 --SearchResult_AnnotationConfig.HasString,
 --SearchResult_AnnotationConfig.HasFloat,
 --SearchResult_AnnotationConfig.HasBlob, 
 --SearchResult_AnnotationConfig.HasBit,
 --SearchResult_Event_Annotation.ValueText,
 --SearchResult_Event_Annotation.ValueInt ,
 --SearchResult_Event_Annotation.ValueFloat,
 --SearchResult_Event_Annotation.ValueBit,
 --SearchResult_Event_Annotation.ValueBlob,  
 CAST(CASE 
	WHEN SearchResult_AnnotationConfig.HasInteger=1 THEN CONVERT(nvarchar, SearchResult_Event_Annotation.ValueInt)
	WHEN SearchResult_AnnotationConfig.HasString=1 THEN CONVERT(nvarchar, SearchResult_Event_Annotation.ValueText)
	WHEN SearchResult_AnnotationConfig.HasFloat=1 THEN CONVERT(nvarchar, SearchResult_Event_Annotation.ValueFloat)
	WHEN SearchResult_AnnotationConfig.HasBit=1 THEN CONVERT(nvarchar, SearchResult_Event_Annotation.ValueBit)	
	ELSE NULL
 END as varchar(80)) AS Value
INTO #PivotBase 
FROM SearchResult_Event 
INNER JOIN SearchResult ON SearchResult_Event.SearchResultId = SearchResult.SearchResultId 
LEFT OUTER JOIN Event ON SearchResult_Event.EventId = Event.EventId 
RIGHT OUTER JOIN SearchResult_AnnotationConfig ON SearchResult.SearchResultId = SearchResult_AnnotationConfig.SearchResultId 
FULL OUTER JOIN SearchResult_Event_Annotation ON  SearchResult_AnnotationConfig.SearchResultAnnotationConfigId = SearchResult_Event_Annotation.SearchResultAnnotationConfigId AND  SearchResult_Event.SearchResultEventId = SearchResult_Event_Annotation.SearchResultEventId 
ORDER BY 
SearchResult.SearchResultId, 
Event.EventId,
SearchResult_Event.SearchResultEventId, 
SearchResult_AnnotationConfig.SearchResultAnnotationConfigId

--SELECT * FROM #PivotBase WHERE Value IS NOT NULL
SELECT * INTO #PivotBase2 FROM #PivotBase  WHERE Value IS NOT NULL 
SELECT * FROM #PivotBase2 

DECLARE @Columns AS VARCHAR(MAX)
SELECT @Columns = COALESCE(@Columns + ',[Annotation' + CAST(AnnotationFieldName as varchar) + ']',  '[Annotation' + cast(AnnotationFieldName as varchar)+ ']')  FROM (SELECT Distinct AnnotationFieldName FROM #PivotBase) AS B
PRINT @Columns

DECLARE @PivotSQl AS VARCHAR(MAX)
SET @PivotSQl = 
	N'SELECT  '+
	--N'SearchResultId,'+
	--N'SearchResultComment,'+
	--N'SearchResultEventId, '+
	N'EventId, '+
	--N'EventStart,'+
	--N'EventStop,'+
	--N'EventDuration,'+
	@Columns+
	N' FROM (SELECT * FROM #PivotBase) AS src '+
	N' PIVOT('+
    N'  MAX(Value)'+
	N'  FOR AnnotationFieldName'+
    N'  IN (' + @Columns + ')'+
	N') AS piv'
PRINT @PivotSql

EXEC(@PivotSql)