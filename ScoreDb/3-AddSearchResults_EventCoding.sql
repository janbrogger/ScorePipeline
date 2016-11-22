USE [HolbergAnon]
GO

CREATE TABLE [dbo].[SearchResult_EventCoding](
	[SearchResultEventCodingId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultStudyId] [int] NOT NULL,
	[EventCodingId] [int] NOT NULL,
 CONSTRAINT [PK_SearchResultEventCoding] PRIMARY KEY CLUSTERED 
(
	[SearchResultEventCodingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_EventCoding]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_EventCoding_EventCoding] FOREIGN KEY([EventCodingId])
REFERENCES [dbo].[EventCoding] ([EventCodingId])
GO

ALTER TABLE [dbo].[SearchResult_EventCoding] CHECK CONSTRAINT [FK_SearchResult_EventCoding_EventCoding]
GO

ALTER TABLE [dbo].[SearchResult_EventCoding]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_EventCoding_SearchResult_Study] FOREIGN KEY([SearchResultStudyId])
REFERENCES [dbo].[SearchResult_Study] ([SearchResultStudyId])
GO

ALTER TABLE [dbo].[SearchResult_EventCoding] CHECK CONSTRAINT [FK_SearchResult_EventCoding_SearchResult_Study]
GO


