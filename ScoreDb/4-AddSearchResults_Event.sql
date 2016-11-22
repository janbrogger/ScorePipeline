USE [HolbergAnon]
GO

CREATE TABLE [dbo].[SearchResult_Event](
	[SearchResultEventId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultEventCodingId] [int] NOT NULL,
	[EventId] [int] NOT NULL,
 CONSTRAINT [PK_SearchResultEvent] PRIMARY KEY CLUSTERED 
(
	[SearchResultEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[SearchResult_Event]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_Event_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
GO

ALTER TABLE [dbo].[SearchResult_Event] CHECK CONSTRAINT [FK_SearchResult_Event_Event]
GO

ALTER TABLE [dbo].[SearchResult_Event]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_EventCoding_SearchResult_Event] FOREIGN KEY([SearchResultEventId])
REFERENCES [dbo].[SearchResult_EventCoding] ([SearchResultEventCodingId])
GO

ALTER TABLE [dbo].[SearchResult_Event] CHECK CONSTRAINT [FK_SearchResult_EventCoding_SearchResult_Event]
GO


