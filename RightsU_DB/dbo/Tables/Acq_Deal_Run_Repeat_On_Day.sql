CREATE TABLE [dbo].[Acq_Deal_Run_Repeat_On_Day] (
    [Acq_Deal_Run_Repeat_On_Day_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Run_Code]               INT NULL,
    [Day_Code]                        INT NULL,
    CONSTRAINT [PK_Acq_Deal_Run_Repeat_On_Day] PRIMARY KEY CLUSTERED ([Acq_Deal_Run_Repeat_On_Day_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Run_Repeat_On_Day_Acq_Deal_Run] FOREIGN KEY ([Acq_Deal_Run_Code]) REFERENCES [dbo].[Acq_Deal_Run] ([Acq_Deal_Run_Code])
);

