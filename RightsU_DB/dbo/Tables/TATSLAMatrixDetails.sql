CREATE TABLE [dbo].[TATSLAMatrixDetails] (
    [TATSLAMatrixDetailCode] INT      IDENTITY (1, 1) NOT NULL,
    [TATSLAMatrixCode]       INT      NULL,
    [UserCode]               INT      NULL,
    [InsertedOn]             DATETIME NULL,
    [InsertedBy]             INT      NULL,
    [UpdatedOn]              DATETIME NULL,
    [UpdatedBy]              INT      NULL,
    PRIMARY KEY CLUSTERED ([TATSLAMatrixDetailCode] ASC),
    CONSTRAINT [FK_TATSLAMatrix] FOREIGN KEY ([TATSLAMatrixCode]) REFERENCES [dbo].[TATSLAMatrix] ([TATSLAMatrixCode])
);

