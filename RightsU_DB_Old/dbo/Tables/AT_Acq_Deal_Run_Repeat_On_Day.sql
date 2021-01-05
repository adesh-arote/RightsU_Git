CREATE TABLE [dbo].[AT_Acq_Deal_Run_Repeat_On_Day] (
    [AT_Acq_Deal_Run_Repeat_On_Day_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Run_Code]               INT NULL,
    [Day_Code]                           INT NULL,
    [Acq_Deal_Run_Repeat_On_Day_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Run_Repeat_On_Day] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Run_Repeat_On_Day_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Run_Repeat_On_Day_AT_Acq_Deal_Run] FOREIGN KEY ([AT_Acq_Deal_Run_Code]) REFERENCES [dbo].[AT_Acq_Deal_Run] ([AT_Acq_Deal_Run_Code])
);

