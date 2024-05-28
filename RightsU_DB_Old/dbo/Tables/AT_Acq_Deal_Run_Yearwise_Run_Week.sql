CREATE TABLE [dbo].[AT_Acq_Deal_Run_Yearwise_Run_Week] (
    [AT_Acq_Deal_Run_Yearwise_Run_Week_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Run_Yearwise_Run_Code]      INT      NULL,
    [AT_Acq_Deal_Run_Code]                   INT      NULL,
    [Start_Week_Date]                        DATETIME NULL,
    [End_Week_Date]                          DATETIME NULL,
    [Is_Preferred]                           CHAR (1) NULL,
    [Inserted_By]                            INT      NULL,
    [Inserted_On]                            DATETIME NULL,
    [Last_action_By]                         INT      NULL,
    [Last_updated_Time]                      DATETIME NULL,
    [Acq_Deal_Run_Yearwise_Run_Week_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Run_Yearwise_Run_Week] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Run_Yearwise_Run_Week_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Run_Yearwise_Run_Week_AT_Acq_Deal_Run_Yearwise_Run] FOREIGN KEY ([AT_Acq_Deal_Run_Yearwise_Run_Code]) REFERENCES [dbo].[AT_Acq_Deal_Run_Yearwise_Run] ([AT_Acq_Deal_Run_Yearwise_Run_Code])
);

