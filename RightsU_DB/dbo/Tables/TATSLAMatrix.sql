CREATE TABLE [dbo].[TATSLAMatrix] (
    [TATSLAMatrixCode] INT      IDENTITY (1, 1) NOT NULL,
    [TATSLACode]       INT      NULL,
    [TATSLAStatusCode] INT      NULL,
    [LevelNo]          INT      NULL,
    [FromDay]          INT      NULL,
    [ToDay]            INT      NULL,
    [InsertedOn]       DATETIME NULL,
    [InsertedBy]       INT      NULL,
    [UpdatedOn]        DATETIME NULL,
    [UpdatedBy]        INT      NULL,
    PRIMARY KEY CLUSTERED ([TATSLAMatrixCode] ASC),
    CONSTRAINT [FK_TATSLA] FOREIGN KEY ([TATSLACode]) REFERENCES [dbo].[TATSLA] ([TATSLACode])
);

