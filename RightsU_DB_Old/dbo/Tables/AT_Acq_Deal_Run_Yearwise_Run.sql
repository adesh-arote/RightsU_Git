CREATE TABLE [dbo].[AT_Acq_Deal_Run_Yearwise_Run] (
    [AT_Acq_Deal_Run_Yearwise_Run_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Run_Code]              INT      NULL,
    [Start_Date]                        DATETIME NULL,
    [End_Date]                          DATETIME NULL,
    [No_Of_Runs]                        INT      NULL,
    [No_Of_Runs_Sched]                  INT      NULL,
    [No_Of_AsRuns]                      INT      NULL,
    [Inserted_By]                       INT      NULL,
    [Inserted_On]                       DATETIME NULL,
    [Last_action_By]                    INT      NULL,
    [Last_updated_Time]                 DATETIME NULL,
    [Year_No]                           INT      NULL,
    [Acq_Deal_Run_Yearwise_Run_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Run_Yearwise_Run] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Run_Yearwise_Run_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Run_Yearwise_Run_AT_Acq_Deal_Run] FOREIGN KEY ([AT_Acq_Deal_Run_Code]) REFERENCES [dbo].[AT_Acq_Deal_Run] ([AT_Acq_Deal_Run_Code])
);

