CREATE TABLE [dbo].[Integration_Deal] (
    [Integration_Deal_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]         INT      NULL,
    [Record_Status]         CHAR (1) NULL,
    [Created_On]            DATETIME NULL,
    [Process_Start]         DATETIME NULL,
    [Process_End]           DATETIME NULL,
    CONSTRAINT [PK_Integration_Deal] PRIMARY KEY CLUSTERED ([Integration_Deal_Code] ASC)
);

