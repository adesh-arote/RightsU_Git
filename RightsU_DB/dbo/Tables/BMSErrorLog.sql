CREATE TABLE [dbo].[BMSErrorLog] (
    [BMSErrorLogCode] INT          IDENTITY (1, 1) NOT NULL,
    [RecordType]      VARCHAR (20) NULL,
    [RecordCode]      INT          NULL,
    [IsMailSent]      CHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([BMSErrorLogCode] ASC)
);

