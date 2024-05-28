CREATE TABLE [dbo].[Approved_Deal] (
    [Approved_Deal_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Record_Code]        INT      NULL,
    [Deal_Type]          CHAR (1) NULL,
    [Deal_Status]        CHAR (1) NULL,
    [Inserted_On]        DATETIME NULL,
    [Is_Amend]           CHAR (1) NULL,
    [Deal_Rights_Code]   INT      NULL,
    PRIMARY KEY CLUSTERED ([Approved_Deal_Code] ASC)
);

