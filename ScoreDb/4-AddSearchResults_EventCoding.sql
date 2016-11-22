USE [HolbergAnon]
GO

CREATE TABLE [dbo].[SearchResult_EventCoding](
	[SearchResultEventCodingId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultId] [int] NOT NULL,
	[EventCodingId] [int] NOT NULL,
	[WorkflowState] [int] NULL,
	[FileState] [int] NOT NULL CONSTRAINT [DF_SearchResult_EventCoding_FileState]  DEFAULT ((0)),
 CONSTRAINT [PK_SearchResultEventCoding] PRIMARY KEY CLUSTERED 
(
	[SearchResultEventCodingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_EventCoding]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_EventCoding_EventCoding] FOREIGN KEY([EventCodingId])
REFERENCES [dbo].[EventCoding] ([EventCodingId]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[SearchResult_EventCoding] CHECK CONSTRAINT [FK_SearchResult_EventCoding_EventCoding]
GO

ALTER TABLE [dbo].[SearchResult_EventCoding]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_EventCoding_SearchResult] FOREIGN KEY([SearchResultId])
REFERENCES [dbo].[SearchResult] ([SearchResultId]) ON DELETE CASCADE ON UPDATE CASCADE
GO

ALTER TABLE [dbo].[SearchResult_EventCoding] CHECK CONSTRAINT [FK_SearchResult_EventCoding_SearchResult] 
GO


