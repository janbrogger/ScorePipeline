----------------------------
--USE HolbergAnon2
--Drop some temp tables
IF OBJECT_ID('tempdb..PivotResult2') IS NOT NULL DROP TABLE tempdb..PivotResult2
IF OBJECT_ID('tempdb..#AnnotationUsers') IS NOT NULL DROP TABLE #AnnotationUsers
IF OBJECT_ID('tempdb..#AnnotationFields') IS NOT NULL DROP TABLE #AnnotationFields
IF OBJECT_ID('tempdb..#PivotingElements') IS NOT NULL DROP TABLE #PivotingElements
IF OBJECT_ID('tempdb..#AnnotationsAndUsers') IS NOT NULL DROP TABLE #AnnotationsAndUsers
IF OBJECT_ID('tempdb..##PivotResultWithUserIdMultiplex') IS NOT NULL DROP TABLE ##PivotResultWithUserIdMultiplex
GO
--SELECT * FROM tempdb..PivotResult1

--Now pivot a second time 
--Store users who did annotations
SELECT * INTO #AnnotationUsers FROM [User] 	WHERE [User].UserName='jcbr' OR [User].UserName='eivaan'
--SELECT * FROM #AnnotationUsers
--Store fieldnames for annotations
SELECT DISTINCT FieldName INTO #AnnotationFields FROM SearchResult_AnnotationConfig
--SELECT * FROM #AnnotationFields
--Now make columns names for each annotation that includes userid
DECLARE @UserIds AS VARCHAR(MAX)
SELECT @UserIds = COALESCE(@UserIds + ',[' + CAST(UserId as varchar) + ']',  '[' + cast(UserId as varchar)+ ']')   FROM #AnnotationUsers
PRINT @UserIds

--Generate the pivoting parts
SELECT FieldName,        
	   ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS RowNumber,	   
	   N' PIVOT(MIN('+FieldName+') FOR UserId'+CONVERT(nvarchar(10),ROW_NUMBER() OVER(ORDER BY (SELECT 0)))+' IN ('+REPLACE(@UserIds,'[','[F'+FieldName+'_')+
	   N' )) AS piv'+CONVERT(nvarchar(10),ROW_NUMBER() OVER(ORDER BY (SELECT 0))) AS PivotingElement,
	   N' CONCAT(''F'+FieldName+'_'',UserId) AS UserId'+CONVERT(nvarchar(10),ROW_NUMBER() OVER(ORDER BY (SELECT 0))) AS UserIdMultiplexed
    INTO #PivotingElements
	FROM #AnnotationFields
	ORDER BY FieldName
--SELECT * FROM #PivotingElements

SELECT FieldName, 
       #AnnotationUsers.UserId, 
	   CONCAT(FieldName,'_',#AnnotationUsers.UserId ) AS ColumnName, 
	   ROW_NUMBER() OVER(ORDER BY (SELECT 0)) AS RowNumber,	   
	   N'MAX([F'+FieldName+'_'+CONVERT(nvarchar(10),UserId)+']) AS '+CONCAT('Annotation_',FieldName,'_',#AnnotationUsers.UserId ) AS PivotSelectPart	   
	INTO #AnnotationsAndUsers 
	FROM #AnnotationFields
	CROSS JOIN #AnnotationUsers 
	ORDER BY FieldName
--SELECT * FROM #AnnotationsAndUsers

DECLARE @UserIdMultiplexed AS VARCHAR(MAX)
SELECT @UserIdMultiplexed = COALESCE(@UserIdMultiplexed + ',' + UserIdMultiplexed + '',  '' + UserIdMultiplexed+ '') FROM #PivotingElements
PRINT @UserIdMultiplexed	

DECLARE @AnnotationList1 AS VARCHAR(MAX)
SELECT @AnnotationList1 = COALESCE(@AnnotationList1 + ',' + FieldName + '',  '' + FieldName+ '')   FROM (SELECT DISTINCT FieldName FROM SearchResult_AnnotationConfig) AS x
PRINT @AnnotationList1

DECLARE @AnnotationUserCount AS int
SELECT @AnnotationUserCount = COUNT(*) FROM #AnnotationsAndUsers
PRINT @AnnotationUserCount

DECLARE @InitialMaxPart AS VARCHAR(MAX)
SELECT @InitialMaxPart = COALESCE(@InitialMaxPart + ',' + PivotSelectPart, PivotSelectPart )   FROM #AnnotationsAndUsers
PRINT @InitialMaxPart

DECLARE @PivotPart AS VARCHAR(MAX)
SELECT @PivotPart = COALESCE(@PivotPart + PivotingElement, PivotingElement)   FROM #PivotingElements
PRINT @PivotPart

DECLARE @PivotResultWithUserIdMultiplexSql AS VARCHAR(MAX)
SELECT @PivotResultWithUserIdMultiplexSql = CONCAT(
	'SELECT '+
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
	'DescriptionId,'+
	'DescriptionDate,'+
	'RecordingStart,'+
	'RecordingStop,'+
	'RecordingDuration,'+
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
	'SearchResultEventId,'+	
	'EventCodingId,'+
	'EventCodeId,'+
	'EventCodeName,'+
	'CodesetId,'+
	'CodesetCollectionId,'+
	'EventId, '+
	'EventStart,'+
	'EventStop,'+
	'EventDuration,'
	,@UserIdMultiplexed,',',@AnnotationList1,' INTO ##PivotResultWithUserIdMultiplex FROM tempdb..PivotResult1')
PRINT @PivotResultWithUserIdMultiplexSql
EXEC(@PivotResultWithUserIdMultiplexSql)
--SELECT * FROM ##PivotResultWithUserIdMultiplex

DECLARE @PivotSql2 AS VARCHAR(MAX)
SET @PivotSql2 = 
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
	@InitialMaxPart+
	' INTO tempdb..PivotResult2 ' +
	' FROM ##PivotResultWithUserIdMultiplex AS src '+
	@PivotPart +
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
PRINT @PivotSql2
EXEC(@PivotSql2)
SELECT * FROM tempdb..PivotResult2

