----------------------------
USE HolbergAnon
--Drop some temp tables
IF OBJECT_ID('tempdb..#MedicationNumbers') IS NOT NULL DROP TABLE #MedicationNumbers
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames1') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames1
IF OBJECT_ID('tempdb..##CarryOverDynamicColumnNames2') IS NOT NULL DROP TABLE ##CarryOverDynamicColumnNames2
IF OBJECT_ID('tempdb..#MedicationMultiplex') IS NOT NULL DROP TABLE #MedicationMultiplex
IF OBJECT_ID('tempdb..##PivotResult4') IS NOT NULL DROP TABLE ##PivotResult4
GO
--SELECT * FROM ##PivotResult2

SELECT DISTINCT MedicationNumber INTO #MedicationNumbers FROM ##PivotResult3 ORDER BY MedicationNumber
DECLARE @MedicationNumbers AS VARCHAR(MAX)
SELECT @MedicationNumbers= COALESCE(@MedicationNumbers + ',[' + CAST(MedicationNumber as varchar) + ']',  '[' + CAST(MedicationNumber as varchar)+ ']')   
	FROM #MedicationNumbers
PRINT 	@MedicationNumbers

DECLARE @MedicationNumbers2 AS VARCHAR(MAX)
SELECT @MedicationNumbers2= COALESCE(@MedicationNumbers2 + ',[MedicationNameNumber_' + CAST(MedicationNumber as varchar) + ']',  '[MedicationNameNumber_' + CAST(MedicationNumber as varchar)+ ']')   
	FROM #MedicationNumbers
PRINT 	@MedicationNumbers2

DECLARE @MedicationNumbers3 AS VARCHAR(MAX)
SELECT @MedicationNumbers3= COALESCE(@MedicationNumbers3 + ',[MedicationATCNumber_' + CAST(MedicationNumber as varchar) + ']',  '[MedicationATCNumber_' + CAST(MedicationNumber as varchar)+ ']')   
	FROM #MedicationNumbers
PRINT 	@MedicationNumbers3

DECLARE @MedicationColumnNames AS VARCHAR(MAX)
SELECT @MedicationColumnNames=	COALESCE(@MedicationColumnNames +
	',MIN([MedicationNameNumber_' + CAST(MedicationNumber as varchar) + ']) AS MedicationName_' +CAST(MedicationNumber as varchar)+',MIN([MedicationATCNumber_' + CAST(MedicationNumber as varchar) + ']) AS MedicationATC_' +CAST(MedicationNumber as varchar),
	 'MIN([MedicationNameNumber_' + CAST(MedicationNumber as varchar) + ']) AS MedicationName_' +CAST(MedicationNumber as varchar)+',MIN([MedicationATCNumber_' + CAST(MedicationNumber as varchar) + ']) AS MedicationATC_' +CAST(MedicationNumber as varchar))
	FROM #MedicationNumbers
PRINT 	@MedicationColumnNames

SELECT name INTO ##CarryOverDynamicColumnNames1 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..##PivotResult3') AND (name LIKE 'Annotation%')
DECLARE @CarryOverDynamicColumnNames1 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames1= COALESCE(@CarryOverDynamicColumnNames1 + ',' + name,name) FROM ##CarryOverDynamicColumnNames1
PRINT  @CarryOverDynamicColumnNames1

SELECT name INTO ##CarryOverDynamicColumnNames2 FROM tempdb.sys.columns 
    WHERE object_id =object_id('tempdb..##PivotResult3') AND (name LIKE 'IndicationForEEG%')
DECLARE @CarryOverDynamicColumnNames2 AS VARCHAR(MAX)
SELECT @CarryOverDynamicColumnNames2= COALESCE(@CarryOverDynamicColumnNames2 + ',' + name,name) FROM ##CarryOverDynamicColumnNames2
PRINT  @CarryOverDynamicColumnNames2

SELECT *, 
	CONCAT('MedicationNameNumber_',MedicationNumber) AS MedicationNameNumber,
	CONCAT('MedicationATCNumber_', MedicationNumber) AS MedicationATCNumber 
INTO #MedicationMultiplex
FROM ##PivotResult3


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
	@MedicationColumnNames+','+
	'ReferrerId,'+
	'ReferrerLastName,'+
	'ReferrerFirstName,'+
	'ReferrerTitle,'+
	'ReferrerInstitution,'+
	'ReferrerAdress,'+
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
	' INTO ##PivotResult4 ' +
	' FROM #MedicationMultiplex AS src '+	
	'PIVOT(MIN(MedicationName)  FOR MedicationNameNumber  IN ('+@MedicationNumbers2+')) AS piv '+
	'PIVOT(MIN(MedicationATCCode)   FOR MedicationATCNumber  IN ('+@MedicationNumbers3+')) AS piv '+
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
	'ReferrerId,'+
	'ReferrerLastName,'+
	'ReferrerFirstName,'+
	'ReferrerTitle,'+
	'ReferrerInstitution,'+
	'ReferrerAdress,'+
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
SELECT * FROM ##PivotResult4

