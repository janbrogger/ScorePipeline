USE [HolbergAnon]
GO

/****** Object:  Table [dbo].[SearchResult_Event]    Script Date: 06.04.2017 14:42:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult_Event](
	[SearchResultEventId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultId] [int] NOT NULL,
	[EventId] [int] NOT NULL,
	[WorkflowState] [int] NULL,
	[FileState] [int] NOT NULL,
 CONSTRAINT [PK_SearchResultEvent] PRIMARY KEY CLUSTERED 
(
	[SearchResultEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_Event] ADD  CONSTRAINT [DF_SearchResult_Event_FileState]  DEFAULT ((0)) FOR [FileState]
GO

ALTER TABLE [dbo].[SearchResult_Event]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_Event_Event] FOREIGN KEY([EventId])
REFERENCES [dbo].[Event] ([EventId])
GO

ALTER TABLE [dbo].[SearchResult_Event] CHECK CONSTRAINT [FK_SearchResult_Event_Event]
GO

ALTER TABLE [dbo].[SearchResult_Event]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_Event_SearchResult] FOREIGN KEY([SearchResultId])
REFERENCES [dbo].[SearchResult] ([SearchResultId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SearchResult_Event] CHECK CONSTRAINT [FK_SearchResult_Event_SearchResult]
GO


