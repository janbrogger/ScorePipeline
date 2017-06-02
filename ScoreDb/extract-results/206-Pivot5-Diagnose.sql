----------------------------
--USE HolbergAnon2
--Drop some temp tables
IF OBJECT_ID('tempdb..#DiagnoseNumbers') IS NOT NULL DROP TABLE #DiagnoseNumbers
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames1') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames1
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames2') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames2
IF OBJECT_ID('tempdb..#DiagnoseMultiplex') IS NOT NULL DROP TABLE #DiagnoseMultiplex
IF OBJECT_ID('tempdb..PivotResult6') IS NOT NULL DROP TABLE tempdb..PivotResult6
GO
--SELECT * FROM tempdb..PivotResult5

SELECT DISTINCT DiagnoseNumber INTO #DiagnoseNumbers FROM tempdb..PivotResult5 ORDER BY DiagnoseNumber
DECLARE @DiagnoseNumbers AS VARCHAR(MAX)
SELECT @DiagnoseNumbers= COALESCE(@DiagnoseNumbers + ',[' + FORMAT(DiagnoseNumber, '00') + ']',  '[' + FORMAT(DiagnoseNumber, '00')+ ']')   
	FROM #DiagnoseNumbers
PRINT 	@DiagnoseNumbers

DECLARE @DiagnoseNumbers2 AS VARCHAR(MAX)
SELECT @DiagnoseNumbers2= COALESCE(@DiagnoseNumbers2 + ',[DiagnoseNameNumber_' + FORMAT(DiagnoseNumber, '00') + ']',  '[DiagnoseNameNumber_' + FORMAT(DiagnoseNumber, '00')+ ']')   
	FROM #DiagnoseNumbers
PRINT 	@DiagnoseNumbers2

DECLARE @DiagnoseNumbers3 AS VARCHAR(MAX)
SELECT @DiagnoseNumbers3= COALESCE(@DiagnoseNumbers3 + ',[DiagnoseCodeNumber_' + FORMAT(DiagnoseNumber, '00') + ']',  '[DiagnoseCodeNumber_' + FORMAT(DiagnoseNumber, '00')+ ']')   
	FROM #DiagnoseNumbers
PRINT 	@DiagnoseNumbers3

DECLARE @DiagnoseColumnNames AS VARCHAR(MAX)
SELECT @DiagnoseColumnNames=	COALESCE(@DiagnoseColumnNames +
	',MIN([DiagnoseNameNumber_' + FORMAT(DiagnoseNumber, '00') + ']) AS DiagnoseName_' +FORMAT(DiagnoseNumber, '00')+',MIN([DiagnoseCodeNumber_' + FORMAT(DiagnoseNumber, '00') + ']) AS DiagnoseCode_' +FORMAT(DiagnoseNumber, '00'),
	 'MIN([DiagnoseNameNumber_' + FORMAT(DiagnoseNumber, '00') + ']) AS DiagnoseName_' +FORMAT(DiagnoseNumber, '00')+',MIN([DiagnoseCodeNumber_' + FORMAT(DiagnoseNumber, '00') + ']) AS DiagnoseCode_' +FORMAT(DiagnoseNumber, '00'))
	FROM #DiagnoseNumbers
PRINT 	@DiagnoseColumnNames

SELECT name INTO ##CarryOverDynamicColumnNames1 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult5') AND (name LIKE 'Annotation%')
DECLARE @CarryOverDynamicColumnNames1 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames1= COALESCE(@CarryOverDynamicColumnNames1 + ',' + name,name) FROM ##CarryOverDynamicColumnNames1
PRINT  @CarryOverDynamicColumnNames1

SELECT name INTO ##CarryOverDynamicColumnNames2 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult5') AND (name LIKE 'IndicationForEEG%' OR name LIKE 'Medication%' OR name LIKE 'Referrer%')
DECLARE @CarryOverDynamicColumnNames2 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames2= COALESCE(@CarryOverDynamicColumnNames2 + ',' + name,name) FROM ##CarryOverDynamicColumnNames2
PRINT  @CarryOverDynamicColumnNames2

SELECT *, 
	CONCAT('DiagnoseNameNumber_',FORMAT(DiagnoseNumber, '00')) AS DiagnoseNameNumber,
	CONCAT('DiagnoseCodeNumber_', FORMAT(DiagnoseNumber, '00')) AS DiagnoseCodeNumber 
INTO #DiagnoseMultiplex
FROM tempdb..PivotResult5
--SELECT * FROM #DiagnoseMultiplex

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
	@DiagnoseColumnNames+','+	
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
	'RecordingStart,'+
	'RecordingStop,'+
	'RecordingDuration,'+
	'RecordingNumber,'+
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
	' INTO tempdb..PivotResult6 ' +
	' FROM #DiagnoseMultiplex AS src '+	
	'PIVOT(MIN(DiagnoseName)  FOR DiagnoseNameNumber  IN ('+@DiagnoseNumbers2+')) AS piv '+
	'PIVOT(MIN(DiagnoseCode)   FOR DiagnoseCodeNumber  IN ('+@DiagnoseNumbers3+')) AS piv '+
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
	'RecordingStart,'+
	'RecordingStop,'+
	'RecordingDuration,'+
	'RecordingNumber,'+
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
SELECT DiagnoseName_01,DiagnoseName_02,DiagnoseName_03,DiagnoseName_05,DiagnoseName_06,DiagnoseName_07 FROM tempdb..PivotResult6

