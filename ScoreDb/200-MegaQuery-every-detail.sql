SELECT        
 SearchResult.SearchResultId,
 SearchResult.Comment,
 PatientDetails.PatientDetailsId,
 DATEPART(yy, PatientDetails.DateOfBirth) AS PatientDateOfBirthYear,
 DATEDIFF(yy,PatientDetails.DateOfBirth, Recording.Start) AS PatientAgeYears,
 Gender.GenderId AS PatientGenderId,
 Gender.Description AS PatientGender,
 Study.StudyId,
 StudyType.Name AS StudyType,
 IndicationForEEGCoding.IndicationForEEGCodingId,
 IndicationForEEGCode.IndicationForEEGCodeId,
 IndicationForEEGCode.Name AS IndicationForEegName,
 MedicationCoding.MedicationCodingId,
 MedicationCode.MedicationCodeId,
 MedicationCode.Code AS MedicationCodeATC,
 MedicationCode.Name AS MedicationCodeName,
 Study_Alertness.Study_AlertnessId,
 Alertness.AlertnessId,
 Alertness.Description AS AlertnessName,
 ReferrerCoding.ReferrerCodingId,
 Referrer.ReferrerId,
 Referrer.Title AS ReferrerTitle,
 Referrer.FirstName AS ReferrerFirstName,
 Referrer.LastName AS ReferrerLastName,
 Referrer.InstitutionName AS ReferrerInstitution,
 Referrer.Address AS ReferrerAdress,
 Description.DescriptionId,
 Description.Date AS ReportDate,
 Description.Summary AS ReportSummary,
 Description.ClinicalComments AS ReportComments,
 ReportPhysician.UserId AS ReportPhysicianId,
 ReportPhysician.OperatingSystemUserName AS ReportPhysician,
 ReportSupervising.UserId AS ReportSupervisingId,
 ReportSupervising.OperatingSystemUserName AS ReportSupervising,
 ReportTechnician.UserId AS ReportTechnicianId,
 ReportTechnician.OperatingSystemUserName AS ReportTechnician,
 Description.IsDescriptionSigned,
 Description.IsSignedByPhysician,
 Description.IsSignedBySupervisingPhysician,
 Description.IsSignedByTechnician,
 Description.IsDeleted AS ReportIsDeleted,
 Description.IsActive AS ReportIsActive,
 Description.SignedTimeFinalOnServer AS ReportSignedFinalTime,
 Recording.RecordingId,
 Recording.Start AS RecordingStart,
 Recording.Stop AS RecordingStop,
 Recording.Length AS RecordingLength,
 EventCoding.EventCodingId,
 EventCode.EventCodeId,
 EventCode.Name AS EventCodeName,
 Codeset.CodesetId,
 CodesetCollection.CodesetCollectionId,
 SearchResult_Event.SearchResultEventId,
 Event.EventId,
 Event.StartDateTime AS EventStart,
 Event.EndDateTime AS EventStop,
 Event.Duration AS EventDuration,
 EventType2.Name AS EventTypeName,
 SearchResult_Event_Annotation.SearchResultEventAnnotationId,
 User_Annotation.UserId AS AnnotationUserId,
 User_Annotation.OperatingSystemUserName AS AnnotationUsername,
 SearchResult_Event_UserWorkstate.Workstate AS AnnotationUserWorkState, 
 SearchResult_AnnotationConfig.SearchResultAnnotationConfigId,
 SearchResult_AnnotationConfig.FieldName AS AnnotationFieldName,
 SearchResult_AnnotationConfig.HasInteger, 
 SearchResult_AnnotationConfig.HasString,
 SearchResult_AnnotationConfig.HasFloat,
 SearchResult_AnnotationConfig.HasBlob, 
 SearchResult_AnnotationConfig.HasBit,
 SearchResult_Event_Annotation.ValueText,
 SearchResult_Event_Annotation.ValueInt, 
 SearchResult_Event_Annotation.ValueFloat,
 SearchResult_Event_Annotation.ValueBit,
 SearchResult_Event_Annotation.ValueBlob 
FROM SearchResult_Event 
INNER JOIN SearchResult ON SearchResult_Event.SearchResultId = SearchResult.SearchResultId 
LEFT OUTER JOIN Event ON SearchResult_Event.EventId = Event.EventId 
LEFT OUTER JOIN  SearchResult_Event_UserWorkstate ON SearchResult_Event.SearchResultEventId = SearchResult_Event_UserWorkstate.SearchResultEventId 
RIGHT OUTER JOIN SearchResult_AnnotationConfig ON SearchResult.SearchResultId = SearchResult_AnnotationConfig.SearchResultId 
FULL OUTER JOIN SearchResult_Event_Annotation ON  SearchResult_AnnotationConfig.SearchResultAnnotationConfigId = SearchResult_Event_Annotation.SearchResultAnnotationConfigId AND  SearchResult_Event.SearchResultEventId = SearchResult_Event_Annotation.SearchResultEventId 
LEFT OUTER JOIN EventCoding ON Event.EventCodingId = EventCoding.EventCodingId 
LEFT OUTER JOIN EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId 
LEFT OUTER JOIN Codeset ON EventCode.CodesetId = Codeset.CodesetId 
LEFT OUTER JOIN CodesetCollection ON Codeset.CodesetId = CodesetCollection.EventCode 
LEFT OUTER JOIN [User] AS User_Annotation ON SearchResult_Event_Annotation.UserId = User_Annotation.UserId 
LEFT OUTER JOIN EventType2 ON Event.EventType2Id = EventType2.EventType2Id 
LEFT OUTER JOIN Recording ON Event.RecordingId = Recording.RecordingId 
LEFT OUTER JOIN Description ON EventCoding.DescriptionId = Description.DescriptionId 
LEFT OUTER JOIN [User] AS ReportPhysician ON Description.PhysicianId = ReportPhysician.UserId 
LEFT OUTER JOIN [User] AS ReportSupervising ON Description.SupervisingPhysicianId = ReportSupervising.UserId 
LEFT OUTER JOIN [User] AS ReportTechnician ON Description.TechnicianId = ReportTechnician.UserId 
LEFT OUTER JOIN Study ON Description.StudyId = Study.StudyId 
LEFT OUTER JOIN StudyType ON Study.StudyTypeId = StudyType.StudyTypeId						 
LEFT JOIN PatientDetails ON Study.ActivePatientDetailsId = PatientDetails.PatientDetailsId
LEFT OUTER JOIN IndicationForEEGCoding ON Study.StudyId = IndicationForEEGCoding.StudyId
LEFT OUTER JOIN IndicationForEEGCode ON IndicationForEEGCoding.IndicationForEEGCodeId = IndicationForEEGCode.IndicationForEEGCodeId
LEFT OUTER JOIN Gender ON PatientDetails.GenderId = Gender.GenderId
LEFT OUTER JOIN MedicationCoding ON Study.StudyId = MedicationCoding.StudyId
LEFT OUTER JOIN MedicationCode ON MedicationCoding.MedicationCodeId = MedicationCode.MedicationCodeId
LEFT OUTER JOIN Study_Alertness ON Study.StudyId = Study_Alertness.AlertnessId
LEFT OUTER JOIN Alertness ON Alertness.AlertnessId = Study_Alertness.AlertnessId
LEFT OUTER JOIN BrainMRI ON Study.BrainMRIId = BrainMRI.BrainMRIId
LEFT OUTER JOIN ReferrerCoding ON Study.StudyId = ReferrerCoding.StudyId
LEFT OUTER JOIN Referrer ON ReferrerCoding.ReferrerId = Referrer.ReferrerId
WHERE        (Description.IsActive = 1) AND (Description.IsDeleted = 0) AND (Description.IsDescriptionSigned = 1) 
ORDER BY 
SearchResult.SearchResultId, 
PatientDetails.PatientDetailsId, 
Study.StudyId, 
Description.DescriptionId,
Eventcoding.EventCodingId,
Event.EventId,
SearchResult_Event.SearchResultEventId, 
SearchResult_AnnotationConfig.SearchResultAnnotationConfigId