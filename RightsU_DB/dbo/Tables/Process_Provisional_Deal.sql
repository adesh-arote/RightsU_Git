CREATE TABLE [dbo].[Process_Provisional_Deal] (
    [Process_Provisional_Deal_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Provisional_Deal_Code]         INT      NULL,
    [Record_Status]                 CHAR (1) NULL,
    [Created_On]                    DATETIME NULL,
    [Process_Start]                 DATETIME NULL,
    [Process_End]                   DATETIME NULL
);

