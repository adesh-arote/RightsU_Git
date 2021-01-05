CREATE TABLE [dbo].[TAT] (
    [TATCode]          INT            IDENTITY (1, 1) NOT NULL,
    [DraftName]        NVARCHAR (500) NULL,
    [Type]             CHAR (1)       NULL,
    [BusinessUnitCode] INT            NULL,
    [UserCode]         INT            NULL,
    [IsAmend]          CHAR (1)       NULL,
    [DealType]         INT            NULL,
    [TATSLAStatusCode] INT            NULL,
    [InsertedOn]       DATETIME       NULL,
    [InsertedBy]       INT            NULL,
    [UpdatedOn]        DATETIME       NULL,
    [UpdatedBy]        INT            NULL,
    [TATSLACode]       INT            NULL,
    [DealCode]         INT            NULL,
    [MessageID]        NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([TATCode] ASC)
);

