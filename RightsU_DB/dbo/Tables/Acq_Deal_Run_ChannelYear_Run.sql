CREATE TABLE [dbo].[Acq_Deal_Run_ChannelYear_Run] (
    [Acq_Deal_Run_ChannelYear_Run] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Run_Code]            INT      NULL,
    [Start_Date]                   DATETIME NULL,
    [End_Date]                     DATETIME NULL,
    [Channel_Code]                 INT      NULL,
    [Defined_Runs]                 INT      NULL,
    [No_of_Runs_Sched]             INT      NULL,
    [Inserted_By]                  INT      NULL,
    [Inserted_On]                  DATETIME NULL,
    [Last_Action_By]               INT      NULL,
    [Last_Updated_Time]            DATETIME NULL
);

