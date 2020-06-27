CREATE TABLE [dbo].[Email_Notification_Msg] (
    [Email_Notification_Msg_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Email_Msg]                   VARCHAR (5000) NULL,
    [Type]                        CHAR (1)       NULL,
    [Email_Msg_For]               VARCHAR (250)  NULL,
    [BMS_Error_Code] INT NULL, 
    [Error_Warning] CHAR(1) NULL, 
    CONSTRAINT [PK_Email_Notification_Msg] PRIMARY KEY CLUSTERED ([Email_Notification_Msg_Code] ASC)
);

