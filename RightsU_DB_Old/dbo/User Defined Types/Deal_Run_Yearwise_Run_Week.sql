CREATE TYPE [dbo].[Deal_Run_Yearwise_Run_Week] AS TABLE (
    [Deal_Run_Yearwise_Run_Week_Code] INT      NULL,
    [Deal_Run_Yearwise_Run_Code]      INT      NULL,
    [Deal_Run_Code]                   INT      NULL,
    [Start_Week_Date]                 DATETIME NULL,
    [End_Week_Date]                   DATETIME NULL,
    [Is_Preferred]                    CHAR (1) NULL,
    [Inserted_By]                     INT      NULL,
    [Inserted_On]                     DATETIME NULL,
    [Last_action_By]                  INT      NULL,
    [Last_updated_Time]               DATETIME NULL);

