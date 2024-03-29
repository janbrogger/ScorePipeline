USE [HolbergAnon3]
GO

/****** Object:  Table [dbo].[SearchResult_AnnotationConfig]    Script Date: 23.02.2017 19:29:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult_Event_Annotation](
	[SearchResultEventAnnotationId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[SearchResultEventId] [int] NOT NULL,
	[SearchResultAnnotationConfigId] [int] NOT NULL,	
	[ValueText] [nvarchar](255) NULL,
	[ValueInt] [int] NULL,
	[ValueFloat] [float] NULL,	
	[ValueBit] [bit]  NULL,
	[ValueBlob] [nvarchar](max) NULL,
 CONSTRAINT [PK_SearchResult_Event_Annotation] PRIMARY KEY CLUSTERED 
(
	[SearchResultEventAnnotationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_Event_Annotation]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_Event_Annotation] FOREIGN KEY([SearchResultEventId])
REFERENCES [dbo].[SearchResult_Event] ([SearchResultEventId])
GO

ALTER TABLE [dbo].[SearchResult_Event_Annotation] CHECK CONSTRAINT [FK_SearchResult_Event_Annotation]
GO

ALTER TABLE [dbo].[SearchResult_Event_Annotation] ADD  CONSTRAINT [DF_SearchResult_Event_Annotation_ValueBit]  DEFAULT ((0)) FOR [ValueBit]
GO

ALTER TABLE [dbo].[SearchResult_Event_Annotation]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_Event_Config] FOREIGN KEY([SearchResultAnnotationConfigId])
REFERENCES [dbo].[SearchResult_AnnotationConfig] ([SearchResultAnnotationConfigId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[SearchResult_Event_Annotation]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_Event_Annotation_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[SearchResult_Event_Annotation] CHECK CONSTRAINT [FK_SearchResult_Event_Config]
GO