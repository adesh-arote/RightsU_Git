CREATE TABLE [dbo].[Acq_Deal_Run_Channel] (
    [Acq_Deal_Run_Channel_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Run_Code]         INT      NULL,
    [Channel_Code]              INT      NULL,
    [Min_Runs]                  INT      NULL,
    [Max_Runs]                  INT      NULL,
    [No_Of_Runs_Sched]          INT      NULL,
    [No_Of_AsRuns]              INT      NULL,
    [Do_Not_Consume_Rights]     CHAR (1) NULL,
    [Is_Primary]                CHAR (1) NULL,
    [Inserted_By]               INT      NULL,
    [Inserted_On]               DATETIME NULL,
    [Last_action_By]            INT      NULL,
    [Last_updated_Time]         DATETIME NULL,
    CONSTRAINT [PK_Acq_Deal_Run_Channel] PRIMARY KEY CLUSTERED ([Acq_Deal_Run_Channel_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Run_Channel_Acq_Deal_Run] FOREIGN KEY ([Acq_Deal_Run_Code]) REFERENCES [dbo].[Acq_Deal_Run] ([Acq_Deal_Run_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Run_Channel_1]
    ON [dbo].[Acq_Deal_Run_Channel]([Acq_Deal_Run_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Run_Channel_2]
    ON [dbo].[Acq_Deal_Run_Channel]([Channel_Code] ASC);

