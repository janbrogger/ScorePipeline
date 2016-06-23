USE HolbergAnon;
--Show different EventCodes by Codesetcollections
PRINT 'The different EventCodes'
SELECT [CodesetCollectionId],[EventCode]  FROM [Holberg].[dbo].[CodesetCollection]
--Count studies by CodesetCollection
PRINT 'Count of studies by codesets'
SELECT        CodesetCollection.CodesetCollectionId, COUNT(Study.StudyId) AS Count
FROM            Study INNER JOIN CodesetCollection ON Study.CodeSetCollectionId = CodesetCollection.CodesetCollectionId
GROUP BY CodesetCollection.CodesetCollectionId ORDER BY CodesetCollection.CodesetCollectionId
SELECT EventCodeId,Code,Name,CodeSetId FROM EventCode WHERE Name LIKE 'Epileptiform%' ORDER BY EventCodeId
--So for codesetIds 7,31,38,45,52, 59,66,74,84,91, 99, we have many epileptiforms all starting with code 05.
--While for codesetids 109 and 122 we have only one.
--For codesetId 109 it starts with 06.01, is EventCodeId 6203
--For codesetId 122 it starts with 05.01, is EventCodeId 6657

--All epileptiform codes
SELECT EventCodeId,Code,Name,CodeSetId FROM EventCode 
WHERE Name = 'Epileptiform interictal activity' 
OR    Name LIKE 'Epileptiform interictal activity%' 
ORDER BY EventCodeId

--Look for normal sharp codes
SELECT EventCodeId,Code,Name,CodeSetId FROM EventCode  WHERE Name LIKE '%transient%' ORDER BY EventCodeId
--All normal sharp codes
SELECT EventCodeId,Code,Name,CodeSetId FROM EventCode 
WHERE Name = 'Physiologic pattern - Positive occipital sharp transient of sleep (POSTS)' 
OR    Name = 'Physiologic pattern - Sharp transient' 
OR    Name = 'Pattern of uncertain significance - BETS (Benign epileptiform transients of sleep / small sharp spikes)' 
OR    Name = 'Pattern of uncertain significance - Slow-fused transient' 
OR    Name = 'Pattern of uncertain significance - Sharp transient' 
OR    Name = 'Pattern of uncertain significance - Small sharp spikes (Benign epileptiform transients of sleep)' 
ORDER BY EventCodeId

--Look for diagnostic significances
SELECT EventCodeId,Code,Name,CodeSetId FROM EventCode  WHERE Name LIKE '%diag%' ORDER BY EventCodeId


--All findings with all examples from all reports
SELECT     Study.StudyId, Description.DescriptionId, Recording.RecordingId, Recording.FilePath, Recording.FileName, EventCoding.EventCodingId, EventCode.EventCodeId, 
                      EventCode.Name, Event.EventId, Event.StartDateTime, Event.Duration, Event.EndDateTime
FROM         Description INNER JOIN
                      EventCoding ON Description.DescriptionId = EventCoding.DescriptionId INNER JOIN
                      Study ON Description.StudyId = Study.StudyId INNER JOIN
                      Recording ON Study.StudyId = Recording.StudyId INNER JOIN
                      EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId 
                      INNER JOIN Event ON EventCoding.EventCodingId = Event.EventCodingId

--Identify all findings that are epileptiform or normal sharps
SELECT     Study.StudyId, Description.DescriptionId, Recording.RecordingId, Recording.FilePath,
					Recording.FileName, EventCoding.EventCodingId, EventCode.EventCodeId, 
                    EventCode.Name, Event.EventId, Event.StartDateTime, Event.Duration, Event.EndDateTime
FROM         Description 				
				INNER JOIN Study ON Description.StudyId = Study.StudyId 
				INNER JOIN Recording ON Study.StudyId = Recording.StudyId 
				INNER JOIN EventCoding ON Description.DescriptionId = EventCoding.DescriptionId 
				INNER JOIN EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId 
                INNER JOIN Event ON EventCoding.EventCodingId = Event.EventCodingId
WHERE EventCode.Name = 'Epileptiform interictal activity' 
OR    EventCode.Name LIKE 'Epileptiform interictal activity%' 
OR    EventCode.Name = 'Physiologic pattern - Positive occipital sharp transient of sleep (POSTS)' 
OR    EventCode.Name = 'Physiologic pattern - Sharp transient' 
OR    EventCode.Name = 'Pattern of uncertain significance - BETS (Benign epileptiform transients of sleep / small sharp spikes)' 
OR    EventCode.Name = 'Pattern of uncertain significance - Slow-fused transient' 
OR    EventCode.Name = 'Pattern of uncertain significance - Sharp transient' 
OR    EventCode.Name = 'Pattern of uncertain significance - Small sharp spikes (Benign epileptiform transients of sleep)' 
ORDER BY StudyId, DescriptionId, RecordingId, EventCodingId, EventId


--Identify all reports that contain findings that are epileptiform or normal sharps
SELECT     Study.StudyId, Description.DescriptionId, Recording.RecordingId, Recording.FilePath, Recording.FileName
FROM         Description 				
				INNER JOIN Study ON Description.StudyId = Study.StudyId 
				INNER JOIN Recording ON Study.StudyId = Recording.StudyId 
				INNER JOIN EventCoding ON Description.DescriptionId = EventCoding.DescriptionId 
				INNER JOIN EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId 
                --INNER JOIN Event ON EventCoding.EventCodingId = Event.EventCodingId
WHERE EventCode.Name = 'Epileptiform interictal activity' 
OR    EventCode.Name LIKE 'Epileptiform interictal activity%' 
OR    EventCode.Name = 'Physiologic pattern - Positive occipital sharp transient of sleep (POSTS)' 
OR    EventCode.Name = 'Physiologic pattern - Sharp transient' 
OR    EventCode.Name = 'Pattern of uncertain significance - BETS (Benign epileptiform transients of sleep / small sharp spikes)' 
OR    EventCode.Name = 'Pattern of uncertain significance - Slow-fused transient' 
OR    EventCode.Name = 'Pattern of uncertain significance - Sharp transient' 
OR    EventCode.Name = 'Pattern of uncertain significance - Small sharp spikes (Benign epileptiform transients of sleep)' 
ORDER BY StudyId, DescriptionId, RecordingId

--Select DescriptionIds of reports that contain epileptiform or normal sharps
SELECT     DISTINCT(Description.DescriptionId)
		FROM         Description 										
						INNER JOIN EventCoding ON Description.DescriptionId = EventCoding.DescriptionId 
						INNER JOIN EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId 
						INNER JOIN Event ON EventCoding.EventCodingId = Event.EventCodingId
		WHERE (EventCode.Name = 'Epileptiform interictal activity' 
		OR    EventCode.Name LIKE 'Epileptiform interictal activity%' 
		OR    EventCode.Name = 'Physiologic pattern - Positive occipital sharp transient of sleep (POSTS)' 
		OR    EventCode.Name = 'Physiologic pattern - Sharp transient' 
		OR    EventCode.Name = 'Pattern of uncertain significance - BETS (Benign epileptiform transients of sleep / small sharp spikes)' 
		OR    EventCode.Name = 'Pattern of uncertain significance - Slow-fused transient' 
		OR    EventCode.Name = 'Pattern of uncertain significance - Sharp transient' 
		OR    EventCode.Name = 'Pattern of uncertain significance - Small sharp spikes (Benign epileptiform transients of sleep)')
		AND Description.IsActive = 1 AND Description.IsDescriptionSigned = 1
ORDER BY DescriptionId

--Identify all findings from all reports where any finding is epileptiform or normal sharps
SELECT     Patient.PatientId, PatientDetails.DateOfBirth, PatientDetails.GenderId, Study.StudyId, Description.DescriptionId, Recording.RecordingId, Recording.FilePath,
					Recording.FileName, EventCoding.EventCodingId, EventCode.EventCodeId, 
                    EventCode.Name, Event.EventId, Event.StartDateTime, Event.Duration, Event.EndDateTime
FROM         Description 				    
	INNER JOIN Study ON Description.StudyId = Study.StudyId 
	INNER JOIN Patient ON Patient.PatientId = Study.PatientId
	INNER JOIN PatientDetails ON PatientDetails.PatientId = Study.PatientId
	INNER JOIN Recording ON Study.StudyId = Recording.StudyId 
	INNER JOIN EventCoding ON Description.DescriptionId = EventCoding.DescriptionId 
	INNER JOIN EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId 
    INNER JOIN Event ON EventCoding.EventCodingId = Event.EventCodingId
    INNER JOIN (
		SELECT     DISTINCT(Description.DescriptionId)
		FROM         Description 										
						INNER JOIN EventCoding ON Description.DescriptionId = EventCoding.DescriptionId 
						INNER JOIN EventCode ON EventCoding.EventCodeId = EventCode.EventCodeId 
						INNER JOIN Event ON EventCoding.EventCodingId = Event.EventCodingId
		WHERE (EventCode.Name = 'Epileptiform interictal activity' 
		OR    EventCode.Name LIKE 'Epileptiform interictal activity%' 
		OR    EventCode.Name = 'Physiologic pattern - Positive occipital sharp transient of sleep (POSTS)' 
		OR    EventCode.Name = 'Physiologic pattern - Sharp transient' 
		OR    EventCode.Name = 'Pattern of uncertain significance - BETS (Benign epileptiform transients of sleep / small sharp spikes)' 
		OR    EventCode.Name = 'Pattern of uncertain significance - Slow-fused transient' 
		OR    EventCode.Name = 'Pattern of uncertain significance - Sharp transient' 
		OR    EventCode.Name = 'Pattern of uncertain significance - Small sharp spikes (Benign epileptiform transients of sleep)')
		AND Description.IsActive = 1 AND Description.IsDescriptionSigned = 1
	) As innerjoin ON Description.DescriptionId = innerjoin.DescriptionId
WHERE Description.IsActive = 1 AND Description.IsDescriptionSigned = 1	
ORDER BY StudyId, DescriptionId, RecordingId, EventCodingId, EventId


