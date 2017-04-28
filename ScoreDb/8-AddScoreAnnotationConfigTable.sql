USE [HolbergAnon]
GO

/****** Object:  Table [dbo].[SearchResult_AnnotationConfig]    Script Date: 23.02.2017 19:29:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult_AnnotationConfig](
	[SearchResultAnnotationConfigId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultId] [int] NOT NULL,
	[AnnotationLevel] [nvarchar](50) NOT NULL,
	[FieldName] [nvarchar](50) NOT NULL,
	[FieldComment] [nvarchar](255) NULL,
	[HasInteger] [bit] NOT NULL,
	[HasFloat] [bit] NOT NULL,
	[HasString] [bit] NOT NULL,
	[HasBit] [bit] NOT NULL,
	[HasBlob] [bit] NOT NULL,
 CONSTRAINT [PK_SearchResult_AnnotationConfig] PRIMARY KEY CLUSTERED 
(
	[SearchResultAnnotationConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_AnnotationConfig] ADD  CONSTRAINT [DF_SearchResult_AnnotationConfig_HasBit]  DEFAULT ((0)) FOR [HasBit]
GO

ALTER TABLE [dbo].[SearchResult_AnnotationConfig]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_AnnotationConfig_SearchResult] FOREIGN KEY([SearchResultId])
REFERENCES [dbo].[SearchResult] ([SearchResultId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SearchResult_AnnotationConfig] CHECK CONSTRAINT [FK_SearchResult_AnnotationConfig_SearchResult]
GO


