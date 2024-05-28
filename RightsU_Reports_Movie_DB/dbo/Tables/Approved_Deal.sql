CREATE TABLE [dbo].[Approved_Deal] (
    [Approved_Deal_Code] INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Record_Code]        INT      NULL,
    [Deal_Type]          CHAR (1) NULL,
    [Deal_Status]        CHAR (1) NULL,
    [Inserted_On]        DATETIME NULL,
    [Is_Amend]           CHAR (1) NULL,
    [Deal_Rights_Code]   INT      NULL,
    CONSTRAINT [PK__Approved__EA1A43B4282EC419] PRIMARY KEY CLUSTERED ([Approved_Deal_Code] ASC)
);

