CREATE TABLE [dbo].[BMS_Process_Deals] (
    [BMS_Process_Deals_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]          INT      NULL,
    [Record_Status]          CHAR (1) NULL,
    [Created_On]             DATETIME NULL,
    [Process_Start]          DATETIME NULL,
    [Process_End]            DATETIME NULL,
    PRIMARY KEY CLUSTERED ([BMS_Process_Deals_Code] ASC)
);

