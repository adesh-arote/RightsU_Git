CREATE TABLE [dbo].[AT_Syn_Deal_Run_Yearwise_Run] (
    [AT_Syn_Deal_Run_Yearwise_Run_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Run_Code]              INT      NULL,
    [Start_Date]                        DATETIME NULL,
    [End_Date]                          DATETIME NULL,
    [No_Of_Runs]                        INT      NULL,
    [Year_No]                           INT      NULL,
    [Syn_Deal_Run_Yearwise_Run_Code]    INT      NOT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Run_Yearwise_Run] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Run_Yearwise_Run_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Run_Yearwise_Run_AT_Syn_Deal_Run] FOREIGN KEY ([AT_Syn_Deal_Run_Code]) REFERENCES [dbo].[AT_Syn_Deal_Run] ([AT_Syn_Deal_Run_Code])
);

