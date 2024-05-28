CREATE TYPE [dbo].[Deal_Run] AS TABLE (
    [Deal_Run_Code]                INT      NULL,
    [Deal_Code]                    INT      NULL,
    [Run_Type]                     CHAR (1) NULL,
    [No_Of_Runs]                   INT      NULL,
    [No_Of_Runs_Sched]             INT      NULL,
    [No_Of_AsRuns]                 INT      NULL,
    [Is_Yearwise_Definition]       CHAR (1) NULL,
    [Is_Rule_Right]                CHAR (1) NULL,
    [Right_Rule_Code]              INT      NULL,
    [Repeat_Within_Days_Hrs]       CHAR (1) NULL,
    [No_Of_Days_Hrs]               INT      NULL,
    [Is_Channel_Definition_Rights] CHAR (1) NULL,
    [Primary_Channel_Code]         INT      NULL,
    [Run_Definition_Type]          CHAR (1) NULL,
    [Run_Definition_Group_Code]    INT      NULL);

