CREATE TABLE [dbo].[Title_Objection_Type](
	[Objection_Type_Code] [int] IDENTITY(1,1) NOT NULL,
	[Objection_Type_Name] [varchar](max) NULL,
	[Parent_Objection_Type_Code] INT NULL,
	[Is_Active] [char](1) NULL,
	[Inserted_On] [datetime] NULL,
	[Inserted_By] [int] NULL,
	[Last_Updated_Time] [datetime] NULL,
	[Last_Action_By] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Objection_Type_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
