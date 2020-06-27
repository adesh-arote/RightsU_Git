CREATE TABLE [dbo].[Acq_Deal_Movie_Music](
	[Acq_Deal_Movie_Music_Code] [int] IDENTITY(1,1) NOT NULL,
	[Acq_Deal_Movie_Code] [int] NULL,
	[Music_Title_Code] [int] NULL,
	[Is_Active] [char](1) NULL,
	[Inserted_By] [int] NULL,
	[Inserted_On] [datetime] NULL,
	[Last_UpDated_Time] [datetime] NULL,
	[Last_Action_By] [int] NULL,
	[Lock_Time] [datetime] NULL,
 CONSTRAINT [PK_Acq_Deal_Movie_Music] PRIMARY KEY CLUSTERED 
(
	[Acq_Deal_Movie_Music_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dbo].[Acq_Deal_Movie_Music]  WITH CHECK ADD  CONSTRAINT [FK_Acq_Deal_Movie_Music_Music_Title] FOREIGN KEY([Music_Title_Code])
REFERENCES [dbo].[Music_Title] ([Music_Title_Code])
GO

ALTER TABLE [dbo].[Acq_Deal_Movie_Music] CHECK CONSTRAINT [FK_Acq_Deal_Movie_Music_Music_Title]
GO

