CREATE TABLE [dbo].[Title_Objection_Status](
	[Title_Objection_Status_Code] [int] IDENTITY(1,1) NOT NULL,
	[Objection_Status_Name] [nvarchar](max) NULL,
	[Is_Active] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[Title_Objection_Status_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]