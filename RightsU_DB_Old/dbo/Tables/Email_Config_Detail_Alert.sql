CREATE TABLE [dbo].[Email_Config_Detail_Alert] (
    [Email_Config_Detail_Alert_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Email_Config_Detail_Code]       INT      NULL,
    [Mail_Alert_Days]                INT      NULL,
    [Allow_Less_Than]                CHAR (1) NULL,
    CONSTRAINT [PK_Email_Config_Detail_Alert] PRIMARY KEY CLUSTERED ([Email_Config_Detail_Alert_Code] ASC),
    CONSTRAINT [FK_Email_Config_Detail_Alert_Email_Config_Detail] FOREIGN KEY ([Email_Config_Detail_Code]) REFERENCES [dbo].[Email_Config_Detail] ([Email_Config_Detail_Code])
);

