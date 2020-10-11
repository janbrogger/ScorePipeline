--Updates SearchResult_Event with studyids for annotating multiple events per EEG.

USE [HolbergAnon3]
GO

Update SearchResult_Event
SET SearchResult_Event.SearchResultStudyId = SearchResult_Study.SearchResultStudyId
  FROM [HolbergAnon3].[dbo].[SearchResult_Study] 
  INNER JOIN Study ON [SearchResult_Study].StudyId = Study.StudyId
  INNER JOIN EventCoding ON Study.ActiveDescriptionId = EventCoding.DescriptionId
  INNER JOIN Event ON EventCoding.EventCodingId = Event.EventCodingId
  INNER JOIN SearchResult_Event ON Event.EventId = SearchResult_Event.EventId
  WHERE SearchResult_Study.SearchResultId =  SearchResult_Event.SearchResultId AND SearchResult_Study.SearchResultId = 22

