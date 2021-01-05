CREATE TABLE [dbo].[Territory_Deal_Log] (
    [Territory_Deal_Log_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Affected_Date]           DATETIME      NULL,
    [Country_Codes]           VARCHAR (MAX) NULL,
    [Territory_Code]          INT           NULL,
    [Deal_Type]               CHAR (1)      NULL,
    [Deal_Code]               INT           NULL,
    [Deal_Rights_Code]        INT           NULL,
    [User_Code]               INT           NULL,
    CONSTRAINT [PK_Territory_Deal_Log] PRIMARY KEY CLUSTERED ([Territory_Deal_Log_Code] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'S-Syndication, A-Acquisition', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Territory_Deal_Log', @level2type = N'COLUMN', @level2name = N'Deal_Type';

