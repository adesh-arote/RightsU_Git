CREATE TYPE [dbo].[Email_Config_Users_UDT] AS TABLE (
    [Email_Config_Users_UDT_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Email_Config_Code]           INT            NULL,
    [Email_Body]                  NVARCHAR (MAX) NULL,
    [To_Users_Code]               NVARCHAR (MAX) NULL,
    [To_User_Mail_Id]             NVARCHAR (MAX) NULL,
    [CC_Users_Code]               NVARCHAR (MAX) NULL,
    [CC_User_Mail_Id]             NVARCHAR (MAX) NULL,
    [BCC_Users_Code]              NVARCHAR (MAX) NULL,
    [BCC_User_Mail_Id]            NVARCHAR (MAX) NULL,
    [Subject]                     NVARCHAR (MAX) NULL);

