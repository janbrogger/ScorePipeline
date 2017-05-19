USE HolbergAnon
--Drop some temp tables
IF OBJECT_ID('tempdb..##PivotBase') IS NOT NULL DROP TABLE ##PivotBase
GO

--The base query
SELECT        
 SearchResult.SearchResultId,
 SearchResult.Comment AS SearchResultComment, 
 Patient.PatientId,
 PatientDetails.PatientDetailsId,
 Gender.GenderId AS PatientGenderId,
 Gender.Description AS PatientGender,
 DATEPART(yy, PatientDetails.DateOfBirth) AS PatientDateOfBirthYear,
 DATEDIFF(yy,PatientDetails.DateOfBirth, Recording.Start) AS PatientAgeYears,
 Study.StudyId,
 StudyType.StudyTypeId,
 StudyType.Name AS StudyTypeName,
 IndicationForEEGCoding.IndicationForEEGCodingId,
 IndicationForEEGCode.Name AS IndicationForEEG,
 ROW_NUMBER() OVER(PARTITION BY Study.StudyId, SearchResultEventAnnotationId, SearchResult_Event.SearchResultEventId, SearchResult_AnnotationConfig.SearchResultAnnotationConfigId ORDER BY Study.StudyId) AS IndicationForEEGNumber,
 Description.DescriptionId,
 Description.Date AS DescriptionDate,
 Description.IsDescriptionSigned,
 Description.IsSignedByPhysician,
 Description.IsSignedBySupervisingPhysician,
 Description.IsSignedByTechnician,
 ReportPhysician.UserId AS ReportPhysicianId,
 ReportPhysician.OperatingSystemUserName AS ReportPhysician,
 ReportSupervising.UserId AS ReportSupervisingId,
 ReportSupervising.OperatingSystemUserName AS ReportSupervising,
 ReportTechnician.UserId AS ReportTechnicianId,
 ReportTechnician.OperatingSystemUserName AS ReportTechnician,
 CONVERT(nvarchar(2048),Description.Summary) AS ReportSummary,
 CONVERT(nvarchar(2048),Description.ClinicalComments ) AS ReportComments,
 Description.SignedTimeFinalOnServer AS ReportSignedFinalTime,
 Recording.RecordingId,
 Recording.Start AS RecordingStart,
 Recording.Stop AS RecordingStop,
 Recording.Length AS RecordingDuration,
 EventCoding.EventCodingId,
 EventCoding.EventCodeId,
 EventCode.Name AS EventCodeName,
 Codeset.CodesetId,
 CodesetCollection.CodesetCollectionId,
 SearchResult_Event.SearchResultEventId,  
 Event.EventId,  
 Event.StartDateTime AS EventStart,
 Event.EndDateTime AS EventStop,
 Event.Duration AS EventDuration,
 SearchResult_Event_Annotation.SearchResultEventAnnotationId,
 SearchResult_Event_UserWorkstate.Workstate AS AnnotationUserWorkState, 
 SearchResult_AnnotationConfig.SearchResultAnnotationConfigId,
 SearchResult_AnnotationConfig.FieldName AS AnnotationFieldName,
 SearchResult_Event_Annotation.UserId, 
 CAST(CASE 
  WHEN SearchResult_AnnotationConfig.HasInteger=1 THEN CONVERT(nvarchar(max), SearchResult_Event_Annotation.ValueInt)
  WHEN SearchResult_AnnotationConfig.HasString=1 THEN CONVERT(nvarchar(max), SearchResult_Event_Annotation.ValueText)
  WHEN SearchResult_AnnotationConfig.HasFloat=1 THEN CONVERT(nvarchar(max), SearchResult_Event_Annotation.ValueFloat)
  WHEN SearchResult_AnnotationConfig.HasBit=1 THEN CONVERT(nvarchar(max), SearchResult_Event_Annotation.ValueBit)	
  WHEN SearchResult_AnnotationConfig.HasBlob=1 THEN CONVERT(nvarchar(max), SearchResult_Event_Annotation.ValueBlob)	
  ELSE NULL
  END as nvarchar(max)) AS Value 
INTO ##PivotBase 
FROM SearchResult_Event 
INNER JOIN SearchResult ON SearchResult_Event.SearchResultId = SearchResult.SearchResultId 
LEFT OUTER JOIN Event ON SearchResult_Event.EventId = Event.EventId 
RIGHT OUTER JOIN SearchResult_AnnotationConfig ON SearchResult.SearchResultId = SearchResult_AnnotationConfig.SearchResultId 
FULL OUTER JOIN SearchResult_Event_Annotation ON  SearchResult_AnnotationConfig.SearchResultAnnotationConfigId = SearchResult_Event_Annotation.SearchResultAnnotationConfigId AND  SearchResult_Event.SearchResultEventId = SearchResult_Event_Annotation.SearchResultEventId 
LEFT OUTER JOIN SearchResult_Event_UserWorkstate ON SearchResult_Event.SearchResultEventId = SearchResult_Event_UserWorkstate.SearchResultEventId
LEFT OUTER JOIN EventCoding ON Event.EventCodingId = EventCoding.EventCodingId
LEFT OUTER JOIN EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId
LEFT OUTER JOIN Codeset ON EventCode.CodesetId = Codeset.CodesetId
LEFT OUTER JOIN CodesetCollection ON Codeset.CodesetId = CodesetCollection.EventCode
LEFT OUTER JOIN Description ON EventCoding.DescriptionId = Description.DescriptionId
LEFT OUTER JOIN Study ON Description.StudyId = Study.StudyId
LEFT OUTER JOIN IndicationForEEGCoding ON Study.StudyId = IndicationForEEGCoding.StudyId
LEFT OUTER JOIN IndicationForEEGCode ON IndicationForEEGCoding.IndicationForEEGCodeId = IndicationForEEGCode.IndicationForEEGCodeId
LEFT OUTER JOIN StudyType ON Study.StudyTypeId= StudyType.StudyTypeId
LEFT OUTER JOIN Patient ON Study.PatientId = Patient.PatientId
LEFT OUTER JOIN PatientDetails ON Study.ActivePatientDetailsId = PatientDetails.PatientDetailsId
LEFT OUTER JOIN Gender ON PatientDetails.GenderId = Gender.GenderId
LEFT OUTER JOIN Recording ON Event.RecordingId = Recording.RecordingId
LEFT OUTER JOIN [User] AS ReportPhysician ON Description.PhysicianId = ReportPhysician.UserId 
LEFT OUTER JOIN [User] AS ReportSupervising ON Description.SupervisingPhysicianId = ReportSupervising.UserId 
LEFT OUTER JOIN [User] AS ReportTechnician ON Description.TechnicianId = ReportTechnician.UserId 
WHERE IndicationForEEGCoding.IndicationForEEGCodeId IS NOT NULL
ORDER BY 
SearchResult.SearchResultId, 
Event.EventId,
SearchResult_Event.SearchResultEventId, 
SearchResult_AnnotationConfig.SearchResultAnnotationConfigId

SELECT * FROM ##PivotBase