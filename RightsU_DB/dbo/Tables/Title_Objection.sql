CREATE TABLE [dbo].[Title_Objection](
	[Title_Objection_Code] [int] IDENTITY(1,1) NOT NULL,
	[Title_Objection_Status_Code] [int] NULL,
	[Title_Objection_Type_Code] [int] NULL,
	[Title_Code] [int] NULL,
	[Record_Code] [int] NULL,
	[Record_Type] [char](1) NULL,
	[Objection_Start_Date] [datetime] NULL,
	[Objection_End_Date] [datetime] NULL,
	[Objection_Remarks] [nvarchar](max) NULL,
	[Resolution_Remarks] [nvarchar](max) NULL,
	[Inserted_On] [datetime] NULL,
	[Inserted_By] [int] NULL,
	[Last_Updated_Time] [datetime] NULL,
	[Last_Action_By] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Title_Objection_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
