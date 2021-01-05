CREATE TABLE [dbo].[TATStatusLog] (
    [TATStatusLogCode] INT      IDENTITY (1, 1) NOT NULL,
    [TATCode]          INT      NULL,
    [TATSLAStatusCode] INT      NULL,
    [StatusChangedOn]  DATETIME NULL,
    [StatusChangedBy]  INT      NULL,
    PRIMARY KEY CLUSTERED ([TATStatusLogCode] ASC),
    CONSTRAINT [TATStatusLog_Fk] FOREIGN KEY ([TATSLAStatusCode]) REFERENCES [dbo].[TATSLAStatus] ([TATSLAStatusCode])
);

