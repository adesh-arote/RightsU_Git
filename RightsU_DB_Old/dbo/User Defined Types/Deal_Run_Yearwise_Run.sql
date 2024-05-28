CREATE TYPE [dbo].[Deal_Run_Yearwise_Run] AS TABLE (
    [Deal_Run_Yearwise_Run_Code] INT      NULL,
    [Deal_Run_Code]              INT      NULL,
    [Start_Date]                 DATETIME NULL,
    [End_Date]                   DATETIME NULL,
    [No_Of_Runs]                 INT      NULL,
    [No_Of_Runs_Sched]           INT      NULL,
    [No_Of_AsRuns]               INT      NULL,
    [Inserted_By]                INT      NULL,
    [Inserted_On]                DATETIME NULL,
    [Last_action_By]             INT      NULL,
    [Last_updated_Time]          DATETIME NULL);

