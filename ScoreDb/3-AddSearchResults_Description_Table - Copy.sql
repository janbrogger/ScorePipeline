USE [HolbergAnon2]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult_Description](
	[SearchResultDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultId] [int] NOT NULL,
	[DescriptionId] [int] NOT NULL,
	[WorkflowState] [int] NULL,
    [FileState] [int] NOT NULL CONSTRAINT [DF_SearchResult_Description_FileState]  DEFAULT ((0)),
 CONSTRAINT [PK_SearchResult_Description] PRIMARY KEY CLUSTERED 
(
	[SearchResultDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_Description] ADD CONSTRAINT [FK_SearchResult_Description_SearchResult] FOREIGN KEY ([SearchResultId]) REFERENCES [dbo].[SearchResult] ([SearchResultId]) ON DELETE CASCADE ON UPDATE CASCADE

ALTER TABLE [dbo].[SearchResult_Description] ADD CONSTRAINT [FK_SearchResult_Description_Description] FOREIGN KEY ([DescriptionId]) REFERENCES [dbo].[Description] ([DescriptionId]) ON DELETE CASCADE ON UPDATE CASCADE

GO
