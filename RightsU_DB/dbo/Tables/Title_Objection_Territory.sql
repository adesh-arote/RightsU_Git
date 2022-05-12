CREATE TABLE [dbo].[Title_Objection_Territory](
	[Title_Objection_Territory_Code] [int] IDENTITY(1,1) NOT NULL,
	[Title_Objection_Code] [int] NULL,
	[Territory_Type] [char](1) NULL,
	[Country_Code] [int] NULL,
	[Territory_Code] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Title_Objection_Territory_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
