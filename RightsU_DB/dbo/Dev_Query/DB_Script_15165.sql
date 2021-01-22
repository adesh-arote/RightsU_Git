
CREATE TABLE [dbo].[DM_Title_Resolve_Conflict](
	[DM_Title_Resolve_Conflict_Code] [int] IDENTITY(1,1) NOT NULL,
	[Tab_Name] [nvarchar](max) NULL,
	[Master_Type] [nvarchar](max) NULL,
	[Roles] [char](1) NULL,
	[Create_New] [char](1) NULL,
	[Order_No] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[DM_Title_Resolve_Conflict_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[DM_Title_Resolve_Conflict] ON 

GO
INSERT [dbo].[DM_Title_Resolve_Conflict] ([DM_Title_Resolve_Conflict_Code], [Tab_Name], [Master_Type], [Roles], [Create_New], [Order_No]) VALUES (1, N'Genres', N'GE', N'N', N'N', 1)
GO
INSERT [dbo].[DM_Title_Resolve_Conflict] ([DM_Title_Resolve_Conflict_Code], [Tab_Name], [Master_Type], [Roles], [Create_New], [Order_No]) VALUES (2, N'Original Language', N'OL', N'N', N'N', 2)
GO
INSERT [dbo].[DM_Title_Resolve_Conflict] ([DM_Title_Resolve_Conflict_Code], [Tab_Name], [Master_Type], [Roles], [Create_New], [Order_No]) VALUES (3, N'Talent', N'TA', N'Y', N'Y', 3)
GO
INSERT [dbo].[DM_Title_Resolve_Conflict] ([DM_Title_Resolve_Conflict_Code], [Tab_Name], [Master_Type], [Roles], [Create_New], [Order_No]) VALUES (4, N'Title Language', N'TL', N'N', N'N', 4)
GO
INSERT [dbo].[DM_Title_Resolve_Conflict] ([DM_Title_Resolve_Conflict_Code], [Tab_Name], [Master_Type], [Roles], [Create_New], [Order_No]) VALUES (5, N'Title Type', N'TT', N'N', N'N', 5)
GO
INSERT [dbo].[DM_Title_Resolve_Conflict] ([DM_Title_Resolve_Conflict_Code], [Tab_Name], [Master_Type], [Roles], [Create_New], [Order_No]) VALUES (6, N'Program', N'PG', N'N', N'N', 6)
GO
SET IDENTITY_INSERT [dbo].[DM_Title_Resolve_Conflict] OFF
GO

INSERT INTO system_parameter_new (Parameter_Name, Parameter_Value, IsActive)
SELECT 'Is_New_DM_Title_Master_Import','Y','Y'