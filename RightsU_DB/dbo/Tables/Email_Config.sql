CREATE TABLE [dbo].[Email_Config] (
    [Email_Config_Code]      INT            IDENTITY (1, 1) NOT NULL,
    [Email_Type]             VARCHAR (50)   NULL,
    [OnScreen_Notification]  CHAR (1)       NULL,
    [Allow_Config]           CHAR (1)       NULL,
    [IsChannel]              CHAR (1)       NULL,
    [IsBusinessUnit]         CHAR (1)       NULL,
    [Notification_Frequency] CHAR (1)       NULL,
    [Days_Config]            CHAR (1)       NULL,
    [Days_Freq]              VARCHAR (1000) NULL,
    [Remarks]                VARCHAR (500)  NULL,
    [Key]                    VARCHAR (50)   NULL,
    [Is_Include_Job]         CHAR (1)       NULL,
    CONSTRAINT [PK_Email_Config] PRIMARY KEY CLUSTERED ([Email_Config_Code] ASC)
);

