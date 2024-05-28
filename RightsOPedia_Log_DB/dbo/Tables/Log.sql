CREATE TABLE [dbo].[Log] (
    [LogId]           INT           IDENTITY (1, 1) NOT NULL,
    [RequestId]       VARCHAR (50)  NULL,
    [LogLevel]        VARCHAR (10)  NULL,
    [AppId]           INT           NULL,
    [AppName]         VARCHAR (100) NULL,
    [Message]         VARCHAR (MAX) NULL,
    [StackTrace]      VARCHAR (MAX) NULL,
    [CreatedDateTime] DATETIME      NULL
);

