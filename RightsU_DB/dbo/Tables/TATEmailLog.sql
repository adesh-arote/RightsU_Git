CREATE TABLE [dbo].[TATEmailLog] (
    [TATEmailLogCode] INT            IDENTITY (1, 1) NOT NULL,
    [TATCode]         INT            NULL,
    [LevelNo]         INT            NULL,
    [UserCode]        INT            NULL,
    [MailID]          NVARCHAR (50)  NULL,
    [StatusCode]      INT            NULL,
    [SentOn]          DATETIME       NULL,
    [MailBody]        NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([TATEmailLogCode] ASC)
);

