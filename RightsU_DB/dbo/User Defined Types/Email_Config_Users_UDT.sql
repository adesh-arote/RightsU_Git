CREATE TYPE [dbo].[Email_Config_Users_UDT] AS TABLE(
	[Email_Config_Users_UDT_Code] [int] IDENTITY(1,1) NOT NULL,
	[Email_Config_Code] [int] NULL,
	[Email_Body] [nvarchar](max) NULL,
	[To_Users_Code] [nvarchar](max) NULL,
	[To_User_Mail_Id] [nvarchar](max) NULL,
	[CC_Users_Code] [nvarchar](max) NULL,
	[CC_User_Mail_Id] [nvarchar](max) NULL,
	[BCC_Users_Code] [nvarchar](max) NULL,
	[BCC_User_Mail_Id] [nvarchar](max) NULL,
	[Subject] [nvarchar](max) NULL
)