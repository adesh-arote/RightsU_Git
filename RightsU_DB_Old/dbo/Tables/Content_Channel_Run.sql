CREATE TABLE [dbo].[Content_Channel_Run] (
    [Content_Channel_Run_Code]        BIGINT   IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]                   INT      NULL,
    [Acq_Deal_Run_Code]               INT      NULL,
    [Title_Content_Code]              INT      NULL,
    [Title_Code]                      INT      NULL,
    [Channel_Code]                    INT      NULL,
    [Run_Type]                        CHAR (1) NULL,
    [Rights_Start_Date]               DATE     NULL,
    [Rights_End_Date]                 DATE     NULL,
    [Right_Rule_Code]                 INT      NULL,
    [Defined_Runs]                    INT      NULL,
    [Schedule_Runs]                   INT      NULL,
    [Schedule_Utilized_Runs]          INT      NULL,
    [AsRun_Runs]                      INT      NULL,
    [AsRun_Utilized_Runs]             INT      NULL,
    [Prime_Start_Time]                TIME (7) NULL,
    [Prime_End_Time]                  TIME (7) NULL,
    [OffPrime_Start_Time]             TIME (7) NULL,
    [OffPrime_End_Time]               TIME (7) NULL,
    [Prime_Runs]                      INT      NULL,
    [Prime_Schedule_Runs]             INT      NULL,
    [Prime_Schedule_Utilized_Runs]    INT      NULL,
    [Prime_AsRun_Runs]                INT      NULL,
    [Prime_AsRun_Utilized_Runs]       INT      NULL,
    [OffPrime_Runs]                   INT      NULL,
    [OffPrime_Schedule_Runs]          INT      NULL,
    [OffPrime_Schedule_Utilized_Runs] INT      NULL,
    [OffPrime_AsRun_Runs]             INT      NULL,
    [OffPrime_AsRun_Utilized_Runs]    INT      NULL,
    [Inserted_On]                     DATETIME NULL,
    [Updated_On]                      DATETIME NULL,
    [Record_Status]                   CHAR (1) NULL,
    [Is_Archive]                      CHAR (1) NULL,
    [Time_Lag_Simulcast]              TIME (7) NULL,
    [Provisional_Deal_Code]           INT      NULL,
    [Provisional_Deal_Run_Code]       INT      NULL,
    [Deal_Type]                       CHAR (1) NULL,
    [Run_Def_Type]                    CHAR (1) NULL,
    CONSTRAINT [PK_Content_Channel_Run] PRIMARY KEY CLUSTERED ([Content_Channel_Run_Code] ASC),
    CONSTRAINT [FK_Content_Channel_Run_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Content_Channel_Run_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code]),
    CONSTRAINT [FK_Content_Channel_Run_Right_Rule] FOREIGN KEY ([Right_Rule_Code]) REFERENCES [dbo].[Right_Rule] ([Right_Rule_Code]),
    CONSTRAINT [FK_Content_Channel_Run_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code]),
    CONSTRAINT [FK_Content_Channel_Run_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code])
);








GO