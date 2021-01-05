CREATE TABLE [dbo].[Email_Config_Detail] (
    [Email_Config_Detail_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Email_Config_Code]        INT      NULL,
    [OnScreen_Notification]    CHAR (1) NULL,
    [Notification_Frequency]   CHAR (1) NULL,
    [Notification_Days]        INT      NULL,
    [Notification_Time]        TIME (7) NULL,
    CONSTRAINT [PK_Email_Config_Detail] PRIMARY KEY CLUSTERED ([Email_Config_Detail_Code] ASC),
    CONSTRAINT [FK_Email_Config_Detail_Email_Config] FOREIGN KEY ([Email_Config_Code]) REFERENCES [dbo].[Email_Config] ([Email_Config_Code])
);

