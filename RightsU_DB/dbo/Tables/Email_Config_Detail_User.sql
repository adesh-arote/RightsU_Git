CREATE TABLE [dbo].[Email_Config_Detail_User] (
    [Email_Config_Detail_User_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Email_Config_Detail_Code]      INT            NULL,
    [User_Type]                     CHAR (1)       NULL,
    [Security_Group_Code]           INT            NULL,
    [Business_Unit_Codes]           VARCHAR (500)  NULL,
    [User_Codes]                    VARCHAR (500)  NULL,
    [Channel_Codes]                 VARCHAR (500)  NULL,
    [CC_Users]                      VARCHAR (500)  NULL,
    [BCC_Users]                     VARCHAR (500)  NULL,
    [ToUser_MailID]                 NVARCHAR (MAX) NULL,
    [CCUser_MailID]                 NVARCHAR (MAX) NULL,
    [BCCUser_MailID]                NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Email_Config_Detail_User] PRIMARY KEY CLUSTERED ([Email_Config_Detail_User_Code] ASC),
    CONSTRAINT [FK_Email_Config_Detail_User_Email_Config_Detail] FOREIGN KEY ([Email_Config_Detail_Code]) REFERENCES [dbo].[Email_Config_Detail] ([Email_Config_Detail_Code])
);

