CREATE TABLE [dbo].[Integration_Run_Blackouts] (
    [Integration_Run_Blackouts_Code] NUMERIC (8) IDENTITY (1, 1) NOT NULL,
    [Foreign_System_Code]            NUMERIC (8) NULL,
    [Acq_Deal_Run_Code]              NUMERIC (8) NULL,
    [Blackout_Start_Date]            DATETIME    NULL,
    [Blackout_End_Date]              DATETIME    NULL,
    CONSTRAINT [PK_Integration_Run_Blackouts] PRIMARY KEY CLUSTERED ([Integration_Run_Blackouts_Code] ASC)
);

