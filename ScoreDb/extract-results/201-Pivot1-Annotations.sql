USE HolbergAnon2
--Drop some temp tables
IF OBJECT_ID('tempdb..#Columns') IS NOT NULL DROP TABLE #Columns
IF OBJECT_ID('tempdb..PivotResult1') IS NOT NULL DROP TABLE tempdb..PivotResult1
IF OBJECT_ID('tempdb..#AnnotationUsers') IS NOT NULL DROP TABLE #AnnotationUsers
IF OBJECT_ID('tempdb..#AnnotationFields') IS NOT NULL DROP TABLE #AnnotationFields
IF OBJECT_ID('tempdb..#AnnotationsAndUsers') IS NOT NULL DROP TABLE #AnnotationsAndUsers
GO

SELECT DISTINCT FieldName As AnnotationFieldName INTO #Columns FROM SearchResult_AnnotationConfig ORDER BY FieldName
--The definitions of columns on which to pivot
DECLARE @Columns AS VARCHAR(MAX)
SELECT @Columns = COALESCE(@Columns + ',[' + CAST(AnnotationFieldName as varchar) + ']',  '[' + cast(AnnotationFieldName as varchar)+ ']')  FROM #Columns AS B
PRINT @Columns

--Build the pivot query
DECLARE @PivotSQl AS VARCHAR(MAX)
SET @PivotSQl = 
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
	'IndicationForEEGCodingId,'+
	'IndicationForEEG,'+
	'IndicationForEEGNumber,'+
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
	'ReferrerNumber,'+
	'ReferrerType,'+
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
	'SearchResultEventId, '+
	'EventCodingId,'+
	'EventCodeId,'+
	'EventCodeName,'+
	'CodesetId,'+
	'CodesetCollectionId,'+
	'piv.EventId, '+
	'EventStart,'+
	'EventStop,'+
	'EventDuration,'+	
	'piv.UserId, '+
	@Columns+
	' INTO tempdb..PivotResult1 ' +
	' FROM (SELECT * FROM tempdb..PivotBase2) AS src '+
	' PIVOT('+
    '  MIN(src.Value)'+
	'  FOR AnnotationFieldName'+
    '  IN (' + @Columns + ')'+
	') AS piv '
PRINT @PivotSql

EXEC(@PivotSql)
SELECT * FROM tempdb..PivotResult1