CREATE TABLE [dbo].[TATSLA] (
    [TATSLACode]       INT            IDENTITY (1, 1) NOT NULL,
    [TATSLAName]       NVARCHAR (100) NULL,
    [BusinessUnitCode] INT            NULL,
    [DealTypeCode]     INT            NULL,
    [IsActive]         CHAR (1)       NULL,
    [InsertedOn]       DATETIME       NULL,
    [InsertedBy]       INT            NULL,
    [UpdatedOn]        DATETIME       NULL,
    [UpdatedBy]        INT            NULL,
    PRIMARY KEY CLUSTERED ([TATSLACode] ASC)
);

