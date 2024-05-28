CREATE TABLE [dbo].[AT_Acq_Deal_Run] (
    [AT_Acq_Deal_Run_Code]                 INT         IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Code]                     INT         NULL,
    [Run_Type]                             CHAR (1)    NULL,
    [No_Of_Runs]                           INT         NULL,
    [No_Of_Runs_Sched]                     INT         NULL,
    [No_Of_AsRuns]                         INT         NULL,
    [Is_Yearwise_Definition]               CHAR (1)    NULL,
    [Is_Rule_Right]                        CHAR (1)    NULL,
    [Right_Rule_Code]                      INT         NULL,
    [Repeat_Within_Days_Hrs]               CHAR (1)    NULL,
    [No_Of_Days_Hrs]                       INT         NULL,
    [Is_Channel_Definition_Rights]         CHAR (1)    NULL,
    [Primary_Channel_Code]                 INT         NULL,
    [Run_Definition_Type]                  CHAR (3)    NULL,
    [Run_Definition_Group_Code]            INT         NULL,
    [All_Channel]                          VARCHAR (1) NULL,
    [Prime_Start_Time]                     TIME (7)    NULL,
    [Prime_End_Time]                       TIME (7)    NULL,
    [Off_Prime_Start_Time]                 TIME (7)    NULL,
    [Off_Prime_End_Time]                   TIME (7)    NULL,
    [Time_Lag_Simulcast]                   TIME (7)    NULL,
    [Prime_Run]                            INT         NULL,
    [Off_Prime_Run]                        INT         NULL,
    [Prime_Time_Provisional_Run_Count]     INT         NULL,
    [Prime_Time_AsRun_Count]               INT         NULL,
    [Prime_Time_Balance_Count]             INT         NULL,
    [Off_Prime_Time_Provisional_Run_Count] INT         NULL,
    [Off_Prime_Time_AsRun_Count]           INT         NULL,
    [Off_Prime_Time_Balance_Count]         INT         NULL,
    [Acq_Deal_Run_Code]                    INT         NULL,
    [Acq_Deal_Tab_Version_Code]            INT         NULL,
    [Syndication_Runs]                     INT         NULL,
    [Inserted_By]                          INT         NULL,
    [Inserted_On]                          DATETIME    NULL,
    [Last_action_By]                       INT         NULL,
    [Last_updated_Time]                    DATETIME    NULL,
    [Channel_Type]                         CHAR (1)    NULL,
    [Channel_Category_Code]                INT         NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Run] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Run_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Run_AT_Acq_Deal_Run] FOREIGN KEY ([AT_Acq_Deal_Code]) REFERENCES [dbo].[AT_Acq_Deal] ([AT_Acq_Deal_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Run_Channel] FOREIGN KEY ([Primary_Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Run_Right_Rule] FOREIGN KEY ([Right_Rule_Code]) REFERENCES [dbo].[Right_Rule] ([Right_Rule_Code])
);









