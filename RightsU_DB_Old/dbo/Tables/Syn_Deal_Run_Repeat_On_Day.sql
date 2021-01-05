CREATE TABLE [dbo].[Syn_Deal_Run_Repeat_On_Day] (
    [Syn_Deal_Run_Repeat_On_Day_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Run_Code]               INT NULL,
    [Day_Code]                        INT NULL,
    CONSTRAINT [PK_Syn_Deal_Run_Repeat_On_Day] PRIMARY KEY CLUSTERED ([Syn_Deal_Run_Repeat_On_Day_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Run_Repeat_On_Day_Syn_Deal_Run] FOREIGN KEY ([Syn_Deal_Run_Code]) REFERENCES [dbo].[Syn_Deal_Run] ([Syn_Deal_Run_Code])
);

