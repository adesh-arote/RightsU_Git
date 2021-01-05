CREATE TABLE [dbo].[Acq_Deal_Run_Yearwise_Run_Week] (
    [Acq_Deal_Run_Yearwise_Run_Week_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Run_Yearwise_Run_Code]      INT      NULL,
    [Acq_Deal_Run_Code]                   INT      NULL,
    [Start_Week_Date]                     DATETIME NULL,
    [End_Week_Date]                       DATETIME NULL,
    [Is_Preferred]                        CHAR (1) NULL,
    [Inserted_By]                         INT      NULL,
    [Inserted_On]                         DATETIME NULL,
    [Last_action_By]                      INT      NULL,
    [Last_updated_Time]                   DATETIME NULL,
    CONSTRAINT [PK_Acq_Deal_Run_Yearwise_Run_Week] PRIMARY KEY CLUSTERED ([Acq_Deal_Run_Yearwise_Run_Week_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Run_Yearwise_Run_Week_Acq_Deal_Run_Yearwise_Run] FOREIGN KEY ([Acq_Deal_Run_Yearwise_Run_Code]) REFERENCES [dbo].[Acq_Deal_Run_Yearwise_Run] ([Acq_Deal_Run_Yearwise_Run_Code])
);

