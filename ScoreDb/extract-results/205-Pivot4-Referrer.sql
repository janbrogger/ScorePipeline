----------------------------
--USE HolbergAnon2
--Drop some temp tables
IF OBJECT_ID('tempdb..#ReferrerNumbers') IS NOT NULL DROP TABLE #ReferrerNumbers
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames1') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames1
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames2') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames2
IF OBJECT_ID('tempdb..#ReferrerMultiplex') IS NOT NULL DROP TABLE #ReferrerMultiplex
IF OBJECT_ID('tempdb..PivotResult5') IS NOT NULL DROP TABLE tempdb..PivotResult5
GO
--SELECT * FROM ##PivotResult2

SELECT DISTINCT ReferrerNumber INTO #ReferrerNumbers FROM tempdb..PivotResult4 ORDER BY ReferrerNumber
DECLARE @ReferrerNumbers AS VARCHAR(MAX)
SELECT @ReferrerNumbers= COALESCE(@ReferrerNumbers + ',[' + FORMAT(ReferrerNumber, '00') + ']',  '[' + FORMAT(ReferrerNumber, '00')+ ']')   
	FROM #ReferrerNumbers
PRINT 	@ReferrerNumbers

DECLARE @ReferrerColumnNames AS VARCHAR(MAX)
SELECT @ReferrerColumnNames = COALESCE(@ReferrerColumnNames +
		',MIN([ReferrerFirstNameNumber_' + FORMAT(ReferrerNumber, '00') + ']) AS ReferrerFirstName_' +FORMAT(ReferrerNumber, '00')+',MIN([ReferrerLastNameNumber_' + FORMAT(ReferrerNumber,'00') + ']) AS ReferrerLastName_' +FORMAT(ReferrerNumber,'00'),
	     'MIN([ReferrerFirstNameNumber_' + FORMAT(ReferrerNumber, '00') + ']) AS ReferrerFirstName_' +FORMAT(ReferrerNumber, '00')+',MIN([ReferrerLastNameNumber_' + FORMAT(ReferrerNumber,'00') + ']) AS ReferrerLastName_' +FORMAT(ReferrerNumber,'00'))
	FROM #ReferrerNumbers
PRINT 	@ReferrerColumnNames

DECLARE @ReferrerNumbers2 AS VARCHAR(MAX)
SELECT @ReferrerNumbers2= COALESCE(@ReferrerNumbers2 + ',[ReferrerLastNameNumber_' + FORMAT(ReferrerNumber,'00') + ']',  '[ReferrerLastNameNumber_' + FORMAT(ReferrerNumber,'00')+ ']')   
	FROM #ReferrerNumbers
PRINT 	@ReferrerNumbers2

DECLARE @ReferrerNumbers3 AS VARCHAR(MAX)
SELECT @ReferrerNumbers3= COALESCE(@ReferrerNumbers3 + ',[ReferrerFirstNameNumber_' + FORMAT(ReferrerNumber,'00') + ']',  '[ReferrerFirstNameNumber_' + FORMAT(ReferrerNumber,'00')+ ']')   
	FROM #ReferrerNumbers
PRINT 	@ReferrerNumbers3

SELECT name INTO ##CarryOverDynamicColumnNames1 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult4') AND (name LIKE 'Annotation%')
DECLARE @CarryOverDynamicColumnNames1 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames1= COALESCE(@CarryOverDynamicColumnNames1 + ',' + name,name) FROM ##CarryOverDynamicColumnNames1
PRINT  @CarryOverDynamicColumnNames1

SELECT name INTO ##CarryOverDynamicColumnNames2 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..PivotResult4') AND (name LIKE 'IndicationForEEG_%' OR name LIKE 'MedicationName_%' OR name LIKE 'MedicationATC_%')
DECLARE @CarryOverDynamicColumnNames2 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames2= COALESCE(@CarryOverDynamicColumnNames2 + ',' + name,name) FROM ##CarryOverDynamicColumnNames2
PRINT  @CarryOverDynamicColumnNames2

SELECT *, 
	CONCAT('ReferrerFirstNameNumber_',FORMAT(ReferrerNumber,'00')) AS ReferrerFirstNameNumber,
	CONCAT('ReferrerLastNameNumber_', FORMAT(ReferrerNumber,'00')) AS ReferrerLastNameNumber 
INTO #ReferrerMultiplex
FROM tempdb..PivotResult4
--SELECT * FROM #ReferrerMultiplex

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
	@ReferrerColumnNames+','+	
	'DiagnoseCode,'+
	'DiagnoseName,'+
	'DiagnoseNumber,'+	
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
	' INTO tempdb..PivotResult5 ' +
	' FROM #ReferrerMultiplex AS src '+	
	'PIVOT(MIN(ReferrerLastName)  FOR ReferrerLastNameNumber  IN ('+@ReferrerNumbers2+')) AS piv '+
	'PIVOT(MIN(ReferrerFirstName)  FOR ReferrerFirstNameNumber  IN ('+@ReferrerNumbers3+')) AS piv '+
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
	'DiagnoseCode,'+
	'DiagnoseName,'+
	'DiagnoseNumber,'+
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
SELECT * FROM tempdb..PivotResult5
