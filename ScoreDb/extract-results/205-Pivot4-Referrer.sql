----------------------------
USE HolbergAnon
--Drop some temp tables
IF OBJECT_ID('tempdb..#ReferrerNumbers') IS NOT NULL DROP TABLE #ReferrerNumbers
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames1') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames1
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames2') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames2
IF OBJECT_ID('tempdb..##PivotResult5') IS NOT NULL DROP TABLE ##PivotResult5
GO
--SELECT * FROM ##PivotResult2

SELECT DISTINCT ReferrerNumber INTO #ReferrerNumbers FROM ##PivotResult4 ORDER BY ReferrerNumber
DECLARE @ReferrerNumbers AS VARCHAR(MAX)
SELECT @ReferrerNumbers= COALESCE(@ReferrerNumbers + ',[' + CAST(ReferrerNumber as varchar) + ']',  '[' + CAST(ReferrerNumber as varchar)+ ']')   
	FROM #ReferrerNumbers
PRINT 	@ReferrerNumbers

DECLARE @ReferrerColumnNames AS VARCHAR(MAX)
SELECT @ReferrerColumnNames= COALESCE(@ReferrerColumnNames + ',MIN([' + CAST(ReferrerNumber as varchar) + ']) AS Referrer_' +CAST(ReferrerNumber as varchar),
																			  'MIN([' + CAST(ReferrerNumber as varchar) + ']) AS Referrer_' +CAST(ReferrerNumber as varchar))   
	FROM #ReferrerNumbers
PRINT 	@ReferrerColumnNames

SELECT name INTO ##CarryOverDynamicColumnNames1 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..##PivotResult4') AND (name LIKE 'Annotation%')
DECLARE @CarryOverDynamicColumnNames1 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames1= COALESCE(@CarryOverDynamicColumnNames1 + ',' + name,name) FROM ##CarryOverDynamicColumnNames1
PRINT  @CarryOverDynamicColumnNames1

SELECT name INTO ##CarryOverDynamicColumnNames2 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..##PivotResult4') AND (name LIKE 'IndicationForEEG_%' OR name LIKE 'MedicationName_%' OR name LIKE 'MedicationATC_%')
DECLARE @CarryOverDynamicColumnNames2 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames2= COALESCE(@CarryOverDynamicColumnNames2 + ',' + name,name) FROM ##CarryOverDynamicColumnNames2
PRINT  @CarryOverDynamicColumnNames2

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
	'EventDuration,'+		
	@CarryOverDynamicColumnNames1+
	' INTO ##PivotResult5 ' +
	' FROM ##PivotResult4 AS src '+	
	'PIVOT(MIN(ReferrerLastName)  FOR ReferrerNumber  IN ('+@ReferrerNumbers+')) AS piv '+
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
SELECT * FROM ##PivotResult5

