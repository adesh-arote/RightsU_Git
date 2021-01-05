CREATE TABLE [dbo].[Acq_Deal_Movie_Music_Link](
	[Acq_Deal_Movie_Music_Link_Code] [int] IDENTITY(1,1) NOT NULL,
	[Acq_Deal_Movie_Music_Code] [int] NULL,
	[Link_Acq_Deal_Movie_Code] [int] NULL,
	[Title_Code] [int] NULL,
	[Episode_No] [int] NULL,
	[No_Of_Play] [int] NULL,
	[Is_Active] [char](1) NULL,
	[Inserted_By] [int] NULL,
	[Inserted_On] [datetime] NULL,
	[Last_UpDated_Time] [datetime] NULL,
	[Last_Action_By] [int] NULL,
	[Lock_Time] [datetime] NULL,
 CONSTRAINT [PK_Acq_Deal_Movie_Music_Link] PRIMARY KEY CLUSTERED 
(
	[Acq_Deal_Movie_Music_Link_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Acq_Deal_Movie_Music_Link]  WITH CHECK ADD  CONSTRAINT [FK_Acq_Deal_Movie_Music_Link_Acq_Deal_Movie_Music] FOREIGN KEY([Acq_Deal_Movie_Music_Code])
REFERENCES [dbo].[Acq_Deal_Movie_Music] ([Acq_Deal_Movie_Music_Code])
GO

ALTER TABLE [dbo].[Acq_Deal_Movie_Music_Link] CHECK CONSTRAINT [FK_Acq_Deal_Movie_Music_Link_Acq_Deal_Movie_Music]
GO

ALTER TABLE [dbo].[Acq_Deal_Movie_Music_Link]  WITH CHECK ADD  CONSTRAINT [FK_Acq_Deal_Movie_Music_Link_Title] FOREIGN KEY([Title_Code])
REFERENCES [dbo].[Title] ([Title_Code])
GO

ALTER TABLE [dbo].[Acq_Deal_Movie_Music_Link] CHECK CONSTRAINT [FK_Acq_Deal_Movie_Music_Link_Title]
GO

