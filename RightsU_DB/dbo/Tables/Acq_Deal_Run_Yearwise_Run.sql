CREATE TABLE [dbo].[Acq_Deal_Run_Yearwise_Run] (
    [Acq_Deal_Run_Yearwise_Run_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Run_Code]              INT      NULL,
    [Start_Date]                     DATETIME NULL,
    [End_Date]                       DATETIME NULL,
    [No_Of_Runs]                     INT      NULL,
    [No_Of_Runs_Sched]               INT      NULL,
    [No_Of_AsRuns]                   INT      NULL,
    [Inserted_By]                    INT      NULL,
    [Inserted_On]                    DATETIME NULL,
    [Last_action_By]                 INT      NULL,
    [Last_updated_Time]              DATETIME NULL,
    [Year_No]                        INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Run_Yearwise_Run] PRIMARY KEY CLUSTERED ([Acq_Deal_Run_Yearwise_Run_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Run_Yearwise_Run_Acq_Deal_Run] FOREIGN KEY ([Acq_Deal_Run_Code]) REFERENCES [dbo].[Acq_Deal_Run] ([Acq_Deal_Run_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Run_Yearwise_Run_1]
    ON [dbo].[Acq_Deal_Run_Yearwise_Run]([Acq_Deal_Run_Code] ASC);

