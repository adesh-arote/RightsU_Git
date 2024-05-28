CREATE TABLE [dbo].[TraceExtended] (
    [TraceId]           INT          NOT NULL,
    [RequestId]         VARCHAR (50) NULL,
    [IsLoginSuccessful] BIT          NULL,
    CONSTRAINT [PK_TraceExtended] PRIMARY KEY CLUSTERED ([TraceId] ASC)
);

