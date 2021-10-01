CREATE TABLE [dbo].[Title_Objection_Rights_Period](
	[Title_Objection_Rights_Period_Code] [int] IDENTITY(1,1) NOT NULL,
	[Title_Objection_Code] [int] NULL,
	[Rights_Start_Date] [datetime] NULL,
	[Rights_End_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Title_Objection_Rights_Period_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]