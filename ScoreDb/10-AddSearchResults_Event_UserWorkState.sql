USE [HolbergAnon3]
GO

/****** Object:  Table [dbo].[SearchResult_Event_UserWorkstate]    Script Date: 06.04.2017 14:43:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult_Event_UserWorkstate](
	[SearchResult_Event_UserWorkstateId] [int] IDENTITY(1,1) NOT NULL,
	[SearchResultEventId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Workstate] [int] NOT NULL,
 CONSTRAINT [PK_SearchResult_Event_UserWorkstate] PRIMARY KEY CLUSTERED 
(
	[SearchResult_Event_UserWorkstateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchResult_Event_UserWorkstate] ADD  CONSTRAINT [DF_SearchResult_Event_UserWorkstate_Workstate]  DEFAULT ((0)) FOR [Workstate]
GO


