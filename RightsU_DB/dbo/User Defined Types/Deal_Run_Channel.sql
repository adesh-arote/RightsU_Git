CREATE TYPE [dbo].[Deal_Run_Channel] AS TABLE (
    [Deal_Run_Channel_Code] INT      NULL,
    [Deal_Run_Code]         INT      NULL,
    [Channel_Code]          INT      NULL,
    [Min_Runs]              INT      NULL,
    [Max_Runs]              INT      NULL,
    [No_Of_Runs_Sched]      INT      NULL,
    [No_Of_AsRuns]          INT      NULL,
    [Do_Not_Consume_Rights] CHAR (1) NULL,
    [Is_Primary]            CHAR (1) NULL,
    [Inserted_By]           INT      NULL,
    [Inserted_On]           DATETIME NULL,
    [Last_action_By]        INT      NULL,
    [Last_updated_Time]     DATETIME NULL);

