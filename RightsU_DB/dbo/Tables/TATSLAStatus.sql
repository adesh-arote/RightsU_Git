CREATE TABLE [dbo].[TATSLAStatus] (
    [TATSLAStatusCode] INT           IDENTITY (1, 1) NOT NULL,
    [TATSLAStatusName] NVARCHAR (50) NULL,
    [IsActive]         CHAR (1)      NULL,
    [IsSLAEmail]       CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([TATSLAStatusCode] ASC)
);

