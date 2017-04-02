USE [HolbergAnon]
GO

/****** Object:  Table [dbo].[SearchResult]    Script Date: 02.04.2017 22:12:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult](
	[SearchResultId] [int] IDENTITY(1,1) NOT NULL,
	[SearchSavedId] [int] NULL,
	[DatePerformed] [datetime] NULL,
	[Comment] [nvarchar](255) NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_SearchResult] PRIMARY KEY CLUSTERED 
(
	[SearchResultId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult]  WITH CHECK ADD  CONSTRAINT [FK_SearchResult_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
GO

ALTER TABLE [dbo].[SearchResult] CHECK CONSTRAINT [FK_SearchResult_User]
GO


