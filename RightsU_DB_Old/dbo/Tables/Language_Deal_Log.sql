CREATE TABLE [dbo].[Language_Deal_Log] (
    [Language_Deal_Log_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Affected_Date]          DATETIME      NULL,
    [Language_Codes]         VARCHAR (MAX) NULL,
    [Language_Group_Code]    INT           NULL,
    [Language_Type]          CHAR (1)      NULL,
    [Deal_Type]              CHAR (1)      NULL,
    [Deal_Code]              INT           NULL,
    [Deal_Rights_Code]       INT           NULL,
    [User_Code]              INT           NULL,
    CONSTRAINT [PK_Language_Deal_Log] PRIMARY KEY CLUSTERED ([Language_Deal_Log_Code] ASC)
);

