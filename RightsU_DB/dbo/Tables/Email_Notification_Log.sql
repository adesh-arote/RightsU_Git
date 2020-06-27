CREATE TABLE [dbo].[Email_Notification_Log] (
    [Email_Notification_Log_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Email_Config_Code]           INT             NULL,
    [Created_Time]                DATETIME        NULL,
    [Is_Read]                     CHAR (1)        NULL,
    [Email_Body]                  NVARCHAR (MAX)  NULL,
    [User_Code]                   INT             NULL,
    [Subject]                     NVARCHAR (1000) NULL,
    [Email_Id]                    NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_Email_Notification_Log] PRIMARY KEY CLUSTERED ([Email_Notification_Log_Code] ASC),
    CONSTRAINT [FK_Email_Notification_Log_Email_Config] FOREIGN KEY ([Email_Config_Code]) REFERENCES [dbo].[Email_Config] ([Email_Config_Code])
);

