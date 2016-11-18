USE [HolbergAnon]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult_Study](
	[SearchResultStudyId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultId] [int] NOT NULL,
	[StudyId] [int] NOT NULL,
	[WorkflowState] [int] NULL,
 CONSTRAINT [PK_SearchResult_Study] PRIMARY KEY CLUSTERED 
(
	[SearchResultStudyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_Study] ADD CONSTRAINT [FK_SearchResult] FOREIGN KEY ([SearchResultId]) REFERENCES [dbo].[SearchResult] ([SearchResultId]) ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE [dbo].[SearchResult_Study] ADD CONSTRAINT [FK_SearchResult_Study] FOREIGN KEY ([StudyId]) REFERENCES [dbo].[Study] ([StudyId]) ON DELETE CASCADE ON UPDATE CASCADE

