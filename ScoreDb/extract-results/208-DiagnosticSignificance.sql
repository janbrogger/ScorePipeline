USE HolbergAnon2

IF OBJECT_ID('#DiagnosticSignificances') IS NOT NULL DROP TABLE #DiagnosticSignificances
IF OBJECT_ID('tempdb..#DiagnosticSignificances') IS NOT NULL DROP TABLE #DiagnosticSignificances
IF OBJECT_ID('tempdb..#PivotResult7WithDiagnosticSignificances') IS NOT NULL DROP TABLE #PivotResult7WithDiagnosticSignificances
IF OBJECT_ID('tempdb..#PivotResult7WithDiagnosticSignificancesDistinct') IS NOT NULL DROP TABLE #PivotResult7WithDiagnosticSignificancesDistinct
--SELECT * FROM tempdb..PivotResult7 -- WHERE DescriptionId=4454

SELECT 
PivotResult7.DescriptionId,
EventCoding.EventCodingId AS DiagnosticSignificanceEventCodingId, 
EventCoding.EventCodeId,
CAST(EventCode.Name AS nvarchar(200)) AS DiagnosticSignificanceName,
EventFolder.Name AS EventFolderName
INTO #DiagnosticSignificances
FROM tempdb..PivotResult7
INNER JOIN EventCoding ON PivotResult7.DescriptionId = EventCoding.DescriptionId
INNER JOIN EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId
INNER JOIN EventFolder ON EventCode.EventFolderId = EventFolder.EventFolderId
WHERE EventFolder.Name = 'Diagnostic significance'

--SELECT * FROM #DiagnosticSignificances

SELECT DISTINCT
PivotResult7.*,
#DiagnosticSignificances.DiagnosticSignificanceEventCodingId,
#DiagnosticSignificances.DiagnosticSignificanceName
 INTO #PivotResult7WithDiagnosticSignificances
FROM tempdb..PivotResult7
INNER JOIN #DiagnosticSignificances ON PivotResult7.DescriptionId = #DiagnosticSignificances.DescriptionId


SELECT DISTINCT #PivotResult7WithDiagnosticSignificances.*,
ROW_NUMBER() OVER(PARTITION BY 
		#PivotResult7WithDiagnosticSignificances.StudyId, 
		#PivotResult7WithDiagnosticSignificances.DescriptionId,
		#PivotResult7WithDiagnosticSignificances.EventId
		ORDER BY 
		#PivotResult7WithDiagnosticSignificances.StudyId, 
		#PivotResult7WithDiagnosticSignificances.DescriptionId,
		#PivotResult7WithDiagnosticSignificances.EventId
		) AS DiagnosticSignificanceNumber
INTO #PivotResult7WithDiagnosticSignificancesDistinct
FROM #PivotResult7WithDiagnosticSignificances

--SELECT DiagnosticSignificanceNumber, COUNT(*)  FROM #PivotResult7WithDiagnosticSignificancesDistinct AS Count GROUP BY DiagnosticSignificanceNumber ORDER BY DiagnosticSignificanceNumber

--Now do the pivoting

--Drop some temp tables
IF OBJECT_ID('tempdb..#DiagnosticSignificanceNumbers') IS NOT NULL DROP TABLE #DiagnosticSignificanceNumbers
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames1') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames1
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames2') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames2
IF OBJECT_ID('tempdb..#DiagnosticSignificanceMultiplex') IS NOT NULL DROP TABLE #DiagnosticSignificanceMultiplex
IF OBJECT_ID('tempdb..PivotResult8') IS NOT NULL DROP TABLE tempdb..PivotResult8
GO
--SELECT * FROM tempdb..PivotResult7

SELECT DISTINCT DiagnosticSignificanceNumber INTO #DiagnosticSignificanceNumbers FROM #PivotResult7WithDiagnosticSignificancesDistinct ORDER BY DiagnosticSignificanceNumber
DECLARE @DiagnosticSignificanceNumbers AS VARCHAR(MAX)
SELECT @DiagnosticSignificanceNumbers= COALESCE(@DiagnosticSignificanceNumbers + 
	',[DiagnosticSignificanceNumber_' + FORMAT(DiagnosticSignificanceNumber, '00') + ']',  
	 '[DiagnosticSignificanceNumber_' + FORMAT(DiagnosticSignificanceNumber, '00')+ ']')   
	FROM #DiagnosticSignificanceNumbers
PRINT 	@DiagnosticSignificanceNumbers

DECLARE @DiagnosticSignificanceColumnNames AS VARCHAR(MAX)
SELECT @DiagnosticSignificanceColumnNames=	
	COALESCE(@DiagnosticSignificanceColumnNames +
	',MIN([DiagnosticSignificanceNumber_' + FORMAT(DiagnosticSignificanceNumber, '00') + ']) AS DiagnosticSignificance_' +FORMAT(DiagnosticSignificanceNumber, '00'),
	',MIN([DiagnosticSignificanceNumber_' + FORMAT(DiagnosticSignificanceNumber, '00') + ']) AS DiagnosticSignificance_' +FORMAT(DiagnosticSignificanceNumber, '00'))
	FROM #DiagnosticSignificanceNumbers
PRINT 	@DiagnosticSignificanceColumnNames


SELECT name INTO ##CarryOverDynamicColumnNames1 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult7') AND (name LIKE 'Annotation%')
DECLARE @CarryOverDynamicColumnNames1 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames1= COALESCE(@CarryOverDynamicColumnNames1 + ',' + name,name) FROM ##CarryOverDynamicColumnNames1
PRINT  @CarryOverDynamicColumnNames1

SELECT name INTO ##CarryOverDynamicColumnNames2 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult7') AND (name LIKE 'IndicationForEEG%' OR name LIKE 'Medication%' OR name LIKE 'Referrer%' OR name LIKE 'Diagnose%' OR name LIKE 'Recording%')
DECLARE @CarryOverDynamicColumnNames2 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames2= COALESCE(@CarryOverDynamicColumnNames2 + ',' + name,name) FROM ##CarryOverDynamicColumnNames2
PRINT  @CarryOverDynamicColumnNames2

SELECT *, 
	CONCAT('DiagnosticSignificanceNumber_',FORMAT(DiagnosticSignificanceNumber, '00')) AS DiagnosticSignificanceNumber2
INTO #DiagnosticSignificanceMultiplex
FROM #PivotResult7WithDiagnosticSignificancesDistinct
--SELECT * FROM #DiagnosticSignificanceMultiplex

DECLARE @PivotSql AS VARCHAR(MAX)
SET @PivotSql = 
	'SELECT  '+	
	'SearchResultId,'+
	'SearchResultComment,'+
	'PatientId,'+
	'PatientDetailsId,'+
	'PatientGenderId,'+
	'PatientGender,'+
	'PatientDateOfBirthYear,'+
	'PatientAgeYears,'+
	'StudyId,'+
	'StudyTypeId,'+
	'StudyTypeName,'+
	@CarryOverDynamicColumnNames2+
	@DiagnosticSignificanceColumnNames+','+	
	'DescriptionId,'+
	'DescriptionDate,'+
	'IsDescriptionSigned,'+
	'IsSignedByPhysician,'+
	'IsSignedBySupervisingPhysician,'+
	'IsSignedByTechnician,'+
	'ReportPhysicianId,'+
	'ReportPhysician,'+
	'ReportSupervisingId,'+
	'ReportSupervising,'+
	'ReportTechnicianId,'+
	'ReportTechnician,'+
	'ReportSummary,'+
	'ReportComments,'+
	'ReportSignedFinalTime,'+	
	'EventCodingId,'+
	'EventCodeId,'+
	'EventCodeName,'+
	'CodesetId,'+
	'CodesetCollectionId,'+
	'SearchResultEventId, '+
	'EventId, '+
	'EventStart,'+
	'EventStop,'+
	'EventDuration,'+		
	@CarryOverDynamicColumnNames1+
	' INTO tempdb..PivotResult8 ' +
	' FROM #DiagnosticSignificanceMultiplex AS src '+	
	'PIVOT(MIN(DiagnosticSignificanceName)  FOR DiagnosticSignificanceNumber2  IN ('+@DiagnosticSignificanceNumbers+')) AS piv '+	
	' GROUP BY '+
	'SearchResultId,'+
	'SearchResultComment,'+
	'PatientId,'+
	'PatientDetailsId,'+
	'PatientGenderId,'+
	'PatientGender,'+
	'PatientDateOfBirthYear,'+
	'PatientAgeYears,'+
	'StudyId,'+
	'StudyTypeId,'+
	'StudyTypeName,'+
	@CarryOverDynamicColumnNames2+','+	
	'DescriptionId,'+
	'DescriptionDate,'+
	'IsDescriptionSigned,'+
	'IsSignedByPhysician,'+
	'IsSignedBySupervisingPhysician,'+
	'IsSignedByTechnician,'+
	'ReportPhysicianId,'+
	'ReportPhysician,'+
	'ReportSupervisingId,'+
	'ReportSupervising,'+
	'ReportTechnicianId,'+
	'ReportTechnician,'+
	'ReportSummary,'+
	'ReportComments,'+
	'ReportSignedFinalTime,'+	
	'EventCodingId,'+
	'EventCodeId,'+
	'EventCodeName,'+
	'CodesetId,'+
	'CodesetCollectionId,'+
	'SearchResultEventId,'+
	'EventStart,'+
	'EventStop,'+
	'EventDuration,'+	
	'EventId, '+
	@CarryOverDynamicColumnNames1
PRINT @PivotSql
EXEC(@PivotSql)
SELECT * FROM tempdb..PivotResult8

