CREATE TABLE [dbo].[Title_Objection_Platform](
	[Title_Objection_Platform_Code] [int] IDENTITY(1,1) NOT NULL,
	[Title_Objection_Code] [int] NULL,
	[Platform_Code] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Title_Objection_Platform_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]