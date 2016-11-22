USE [HolbergAnon]
GO

DBCC CHECKIDENT ('SearchResult', RESEED, 0)
GO

INSERT INTO [dbo].[SearchResult] ([SearchSavedId], [DatePerformed],[Comment])
     VALUES (null,'20161115 20:40:00','Manual insert of epi/non-epi sharps search, not using SCORE')
GO

DBCC CHECKIDENT ('SearchResult_Study', RESEED, 1)
GO

--Select studies that match certain event code names
--insert them into the SearchResultStudy table, connecting them to the SearchResult above
-- and give them a workflow state of zero (not started)
INSERT INTO SearchResult_Study
SELECT     SearchResultId=1, Study.StudyId, WorkflowState = 0, FileState=0
FROM         Description 				    
	INNER JOIN Study ON Description.StudyId = Study.StudyId 		
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