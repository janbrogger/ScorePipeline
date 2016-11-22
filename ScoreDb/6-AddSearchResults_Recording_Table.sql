USE [HolbergAnon]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult_Recording](
	[SearchResultRecordingId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultId] [int] NOT NULL,
	[RecordingId] [int] NOT NULL,
	[WorkflowState] [int] NULL,
    [FileState] [int] NOT NULL CONSTRAINT [DF_SearchResult_Recording_FileState]  DEFAULT ((0)),
 CONSTRAINT [PK_SearchResult_Recording] PRIMARY KEY CLUSTERED 
(
	[SearchResultRecordingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_Recording] ADD CONSTRAINT [FK_SearchResult_Recording_SearchResult] FOREIGN KEY ([SearchResultId]) REFERENCES [dbo].[SearchResult] ([SearchResultId]) ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE [dbo].[SearchResult_Recording] ADD CONSTRAINT [FK_SearchResult_Recording_Recording] FOREIGN KEY ([RecordingId]) REFERENCES [dbo].[Recording] ([RecordingId]) ON DELETE CASCADE ON UPDATE CASCADE

GO
