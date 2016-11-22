USE [HolbergAnon]
GO

DBCC CHECKIDENT ('SearchResult', RESEED, 0)
GO


DELETE FROM SearchResult
INSERT INTO [dbo].[SearchResult] ([SearchSavedId], [DatePerformed],[Comment])
     VALUES (null,'20161122 20:40:00','Manual insert of epi/non-epi sharps search, not using SCORE')

DECLARE @NewSearchResultId int
SELECT @NewSearchResultId  = MAX(SearchResultId) FROM SearchResult


DBCC CHECKIDENT ('SearchResult_Study', RESEED, 1)


--DROP TABLE #TempEventCoding
--Start with EventCode 
SELECT     EventCoding.EventCodingId, EventCoding.DescriptionId
INTO #TempEventCoding
		FROM EventCoding											
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


--DROP TABLE #TempEvent
SELECT     Event.EventId, Event.RecordingId
INTO #TempEvent
FROM #TempEventCoding 
INNER JOIN Event ON #TempEventCoding.EventCodingId = Event.EventCodingId
WHERE Event.IsDeleted = 0

SELECT     Recording.RecordingId
INTO #TempRecording
FROM #TempEvent
INNER JOIN Recording ON #TempEvent.RecordingId = Recording.RecordingId
WHERE Recording.IsDeleted = 0

SELECT     Description.DescriptionId, Description.StudyId
INTO #TempDescription
FROM #TempEventCoding
INNER JOIN Description ON #TempEventCoding.DescriptionId = Description.DescriptionId
WHERE Description.IsActive = 1 AND Description.IsDescriptionSigned = 1 AND Description.IsDeleted = 0

SELECT     Study.StudyId
INTO #TempStudy
FROM #TempDescription
INNER JOIN Study ON #TempDescription.StudyId = Study.StudyId
WHERE Study.IsDeleted=0

-----

INSERT INTO SearchResult_Study
SELECT     SearchResultId=@NewSearchResultId , StudyId = #TempStudy.StudyId, WorkflowState = 0, FileState=0
FROM         #TempStudy	

INSERT INTO SearchResult_Description
SELECT     SearchResultId=@NewSearchResultId , DescriptionId = #TempDescription.DescriptionId, WorkflowState = 0, FileState=0
FROM         #TempDescription

INSERT INTO SearchResult_Recording
SELECT     SearchResultId=@NewSearchResultId , RecordingId = #TempRecording.RecordingId, WorkflowState = 0, FileState=0
FROM         #TempRecording

INSERT INTO SearchResult_EventCoding
SELECT     SearchResultId=@NewSearchResultId , EventCodingId = #TempEventCoding.EventCodingId, WorkflowState = 0, FileState=0
FROM         #TempEventCoding

--SET IDENTITY_INSERT SearchResult_Event ON
INSERT INTO SearchResult_Event (SearchResultId, EventId, WorkflowState, FileState)
SELECT     SearchResultId=@NewSearchResultId , EventId = #TempEvent.EventId, WorkflowState = 0, FileState=0
FROM         #TempEvent

GO
