----------------------------
USE HolbergAnon2
--Drop some temp tables
IF OBJECT_ID('tempdb..#IndicationForEegNumbers') IS NOT NULL DROP TABLE #IndicationForEegNumbers
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames
IF OBJECT_ID('tempdb..PivotResult3') IS NOT NULL DROP TABLE tempdb..PivotResult3
GO
--SELECT * FROM tempdb..PivotResult2

SELECT DISTINCT IndicationForEegNumber INTO #IndicationForEegNumbers FROM tempdb..PivotResult2 ORDER BY IndicationForEEGNumber
DECLARE @IndicationForEegNumbers AS VARCHAR(MAX)
SELECT @IndicationForEegNumbers= COALESCE(@IndicationForEegNumbers + ',[' + FORMAT(IndicationForEEGNumber,'00') + ']',  '[' + FORMAT(IndicationForEEGNumber, '00')+ ']')   
	FROM #IndicationForEegNumbers
PRINT 	@IndicationForEegNumbers

DECLARE @IndicationForEegColumnNames AS VARCHAR(MAX)
SELECT @IndicationForEegColumnNames= COALESCE(@IndicationForEegColumnNames + ',MIN([' + FORMAT(IndicationForEEGNumber, '00') + ']) AS IndicationForEEG_' +FORMAT(IndicationForEEGNumber, '00'),
																			  'MIN([' + FORMAT(IndicationForEEGNumber,'00') + ']) AS IndicationForEEG_' +FORMAT(IndicationForEEGNumber, '00'))   
	FROM #IndicationForEegNumbers
PRINT 	@IndicationForEegColumnNames


SELECT name INTO ##CarryOverDynamicColumnNames FROM tempdb.sys.columns WHERE object_id =object_id('tempdb..PivotResult2') AND name LIKE 'Annotation%'
DECLARE @CarryOverDynamicColumnNames AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames= COALESCE(@CarryOverDynamicColumnNames + ',' + name,name) FROM ##CarryOverDynamicColumnNames
PRINT  @CarryOverDynamicColumnNames



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
	@IndicationForEegColumnNames+','+
	'MedicationATCCode,'+
	'MedicationName,'+
	'MedicationNumber,'+
	'DiagnoseCode,'+
	'DiagnoseName,'+
	'DiagnoseNumber,'+
	'ReferrerId,'+
	'ReferrerLastName,'+
	'ReferrerFirstName,'+
	'ReferrerTitle,'+
	'ReferrerInstitution,'+
	'ReferrerAdress,'+
	'ReferrerType,'+
	'ReferrerNumber,'+
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
	'RecordingId,'+
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
	@CarryOverDynamicColumnNames+	
	' INTO tempdb..PivotResult3 ' +
	' FROM tempdb..PivotResult2 AS src '+	
	'PIVOT(MIN(IndicationForEEG)  FOR IndicationForEegNumber  IN ('+@IndicationForEegNumbers+')) AS piv '+
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
	'MedicationATCCode,'+
	'MedicationName,'+
	'MedicationNumber,'+
	'DiagnoseCode,'+
	'DiagnoseName,'+
	'DiagnoseNumber,'+
	'ReferrerId,'+
	'ReferrerLastName,'+
	'ReferrerFirstName,'+
	'ReferrerTitle,'+
	'ReferrerInstitution,'+
	'ReferrerAdress,'+
	'ReferrerType,'+
	'ReferrerNumber,'+
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
	'RecordingId,'+
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
	@CarryOverDynamicColumnNames
PRINT @PivotSql
EXEC(@PivotSql)
SELECT * FROM tempdb..PivotResult3
