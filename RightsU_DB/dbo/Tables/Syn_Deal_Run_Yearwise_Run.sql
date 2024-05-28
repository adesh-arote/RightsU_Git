CREATE TABLE [dbo].[Syn_Deal_Run_Yearwise_Run] (
    [Syn_Deal_Run_Yearwise_Run_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Run_Code]              INT      NULL,
    [Start_Date]                     DATETIME NULL,
    [End_Date]                       DATETIME NULL,
    [No_Of_Runs]                     INT      NULL,
    [Year_No]                        INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Run_Yearwise_Run] PRIMARY KEY CLUSTERED ([Syn_Deal_Run_Yearwise_Run_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Run_Yearwise_Run_Syn_Deal_Run] FOREIGN KEY ([Syn_Deal_Run_Code]) REFERENCES [dbo].[Syn_Deal_Run] ([Syn_Deal_Run_Code])
);

