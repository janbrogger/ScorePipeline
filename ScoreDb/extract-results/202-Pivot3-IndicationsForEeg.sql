----------------------------
USE HolbergAnon
--Drop some temp tables
IF OBJECT_ID('tempdb..#IndicationForEegNumbers') IS NOT NULL DROP TABLE #IndicationForEegNumbers
IF OBJECT_ID('tempdb..##PivotResult3') IS NOT NULL DROP TABLE ##PivotResult3
GO
--SELECT * FROM ##PivotResult2

SELECT DISTINCT IndicationForEegNumber INTO #IndicationForEegNumbers FROM ##PivotResult2 ORDER BY IndicationForEEGNumber
DECLARE @IndicationForEegNumbers AS VARCHAR(MAX)
SELECT @IndicationForEegNumbers= COALESCE(@IndicationForEegNumbers + ',[' + CAST(IndicationForEEGNumber as varchar) + ']',  '[' + CAST(IndicationForEEGNumber as varchar)+ ']')   
	FROM #IndicationForEegNumbers
PRINT 	@IndicationForEegNumbers

DECLARE @IndicationForEegColumnNames AS VARCHAR(MAX)
SELECT @IndicationForEegColumnNames= COALESCE(@IndicationForEegColumnNames + ',MIN([' + CAST(IndicationForEEGNumber as varchar) + ']) AS IndicationForEEG_' +CAST(IndicationForEEGNumber as varchar),
																			  'MIN([' + CAST(IndicationForEEGNumber as varchar) + ']) AS IndicationForEEG_' +CAST(IndicationForEEGNumber as varchar))   
	FROM #IndicationForEegNumbers
PRINT 	@IndicationForEegColumnNames

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
	'EventCodingId,'+
	'EventCodeId,'+
	'EventCodeName,'+
	'CodesetId,'+
	'CodesetCollectionId,'+
	'SearchResultEventId, '+
	'EventId, '+
	'EventStart,'+
	'EventStop,'+
	'EventDuration'+		
	' INTO ##PivotResult3 ' +
	' FROM ##PivotResult2 AS src '+	
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
	'EventCodingId,'+
	'EventCodeId,'+
	'EventCodeName,'+
	'CodesetId,'+
	'CodesetCollectionId,'+
	'SearchResultEventId,'+
	'EventStart,'+
	'EventStop,'+
	'EventDuration,'+	
	'EventId '
PRINT @PivotSql
EXEC(@PivotSql)
SELECT * FROM ##PivotResult3
