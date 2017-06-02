----------------------------
--USE HolbergAnon2
--Drop some temp tables
IF OBJECT_ID('tempdb..#RecordingNumbers') IS NOT NULL DROP TABLE #RecordingNumbers
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames1') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames1
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames2') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames2
IF OBJECT_ID('tempdb..#RecordingMultiplex') IS NOT NULL DROP TABLE #RecordingMultiplex
IF OBJECT_ID('tempdb..PivotResult7') IS NOT NULL DROP TABLE tempdb..PivotResult7
GO
--SELECT * FROM tempdb..PivotResult6

SELECT DISTINCT RecordingNumber INTO #RecordingNumbers FROM tempdb..PivotResult6 ORDER BY RecordingNumber
DECLARE @RecordingNumbers AS VARCHAR(MAX)
SELECT @RecordingNumbers= COALESCE(@RecordingNumbers + ',[' + FORMAT(RecordingNumber, '00') + ']',  '[' + FORMAT(RecordingNumber, '00')+ ']')   
	FROM #RecordingNumbers
PRINT 	@RecordingNumbers

DECLARE @RecordingNumbers2 AS VARCHAR(MAX)
SELECT @RecordingNumbers2= COALESCE(@RecordingNumbers2 + ',[RecordingStart_' + FORMAT(RecordingNumber, '00') + ']',  '[RecordingStart_' + FORMAT(RecordingNumber, '00')+ ']')   
	FROM #RecordingNumbers
PRINT 	@RecordingNumbers2

DECLARE @RecordingNumbers3 AS VARCHAR(MAX)
SELECT @RecordingNumbers3= COALESCE(@RecordingNumbers3 + ',[RecordingStop_' + FORMAT(RecordingNumber, '00') + ']',  '[RecordingStop_' + FORMAT(RecordingNumber, '00')+ ']')   
	FROM #RecordingNumbers
PRINT 	@RecordingNumbers3

DECLARE @RecordingNumbers4 AS VARCHAR(MAX)
SELECT @RecordingNumbers4= COALESCE(@RecordingNumbers4 + ',[RecordingDuration_' + FORMAT(RecordingNumber, '00') + ']',  '[RecordingDuration_' + FORMAT(RecordingNumber, '00')+ ']')   
	FROM #RecordingNumbers
PRINT 	@RecordingNumbers4

DECLARE @RecordingColumnNames AS VARCHAR(MAX)
SELECT @RecordingColumnNames=	COALESCE(@RecordingColumnNames +
	',MIN([RecordingStart_' + FORMAT(RecordingNumber, '00') + ']) AS RecordingStart_' +FORMAT(RecordingNumber, '00')+',MIN([RecordingStop_' + FORMAT(RecordingNumber, '00') + ']) AS RecordingStop_' +FORMAT(RecordingNumber, '00')+',MIN([RecordingDuration_' + FORMAT(RecordingNumber, '00') + ']) AS RecordingDuration_' +FORMAT(RecordingNumber, '00'),
	 'MIN([RecordingStart_' + FORMAT(RecordingNumber, '00') + ']) AS RecordingStart_' +FORMAT(RecordingNumber, '00')+',MIN([RecordingStop_' + FORMAT(RecordingNumber, '00') + ']) AS RecordingStop_' +FORMAT(RecordingNumber, '00')+',MIN([RecordingDuration_' + FORMAT(RecordingNumber, '00') + ']) AS RecordingDuration_' +FORMAT(RecordingNumber, '00'))
	FROM #RecordingNumbers
PRINT 	@RecordingColumnNames

SELECT name INTO ##CarryOverDynamicColumnNames1 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult6') AND (name LIKE 'Annotation%')
DECLARE @CarryOverDynamicColumnNames1 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames1= COALESCE(@CarryOverDynamicColumnNames1 + ',' + name,name) FROM ##CarryOverDynamicColumnNames1
PRINT  @CarryOverDynamicColumnNames1

SELECT name INTO ##CarryOverDynamicColumnNames2 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult6') AND (name LIKE 'IndicationForEEG%' OR name LIKE 'Medication%' OR name LIKE 'Referrer%' OR name LIKE 'Diagnose%')
DECLARE @CarryOverDynamicColumnNames2 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames2= COALESCE(@CarryOverDynamicColumnNames2 + ',' + name,name) FROM ##CarryOverDynamicColumnNames2
PRINT  @CarryOverDynamicColumnNames2

SELECT *, 
	CONCAT('RecordingStart_',FORMAT(RecordingNumber, '00')) AS RecordingStartNumber,
	CONCAT('RecordingStop_', FORMAT(RecordingNumber, '00')) AS RecordingStopNumber, 
	CONCAT('RecordingDuration_', FORMAT(RecordingNumber, '00')) AS RecordingDurationNumber 
INTO #RecordingMultiplex
FROM tempdb..PivotResult6
--SELECT * FROM #RecordingMultiplex

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
	@CarryOverDynamicColumnNames2+','+
	@RecordingColumnNames+','+	
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
	' INTO tempdb..PivotResult7 ' +
	' FROM #RecordingMultiplex AS src '+	
	'PIVOT(MIN(RecordingStart)     FOR RecordingStartNumber  IN ('+@RecordingNumbers2+')) AS piv '+
	'PIVOT(MIN(RecordingStop)      FOR RecordingStopNumber  IN ('+@RecordingNumbers3+')) AS piv '+
	'PIVOT(MIN(RecordingDuration)  FOR RecordingDurationNumber  IN ('+@RecordingNumbers4+')) AS piv '+
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
SELECT * FROM tempdb..PivotResult7 ORDER BY EventStart

