CREATE TABLE [dbo].[AT_Acq_Deal_Run_Channel] (
    [AT_Acq_Deal_Run_Channel_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Run_Code]         INT      NULL,
    [Channel_Code]                 INT      NULL,
    [Min_Runs]                     INT      NULL,
    [Max_Runs]                     INT      NULL,
    [No_Of_Runs_Sched]             INT      NULL,
    [No_Of_AsRuns]                 INT      NULL,
    [Do_Not_Consume_Rights]        CHAR (1) NULL,
    [Is_Primary]                   CHAR (1) NULL,
    [Inserted_By]                  INT      NULL,
    [Inserted_On]                  DATETIME NULL,
    [Last_action_By]               INT      NULL,
    [Last_updated_Time]            DATETIME NULL,
    [Acq_Deal_Run_Channel_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Run_Channel] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Run_Channel_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Run_Channel_AT_Acq_Deal_Run] FOREIGN KEY ([AT_Acq_Deal_Run_Code]) REFERENCES [dbo].[AT_Acq_Deal_Run] ([AT_Acq_Deal_Run_Code])
);

