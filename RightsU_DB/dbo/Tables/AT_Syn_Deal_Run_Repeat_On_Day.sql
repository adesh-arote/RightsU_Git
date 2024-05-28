CREATE TABLE [dbo].[AT_Syn_Deal_Run_Repeat_On_Day] (
    [AT_Syn_Deal_Run_Repeat_On_Day_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Run_Code]               INT NULL,
    [Day_Code]                           INT NULL,
    [Syn_Deal_Run_Repeat_On_Day_Code]    INT NOT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Run_Repeat_On_Day] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Run_Repeat_On_Day_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Run_Repeat_On_Day_AT_Syn_Deal_Run] FOREIGN KEY ([AT_Syn_Deal_Run_Code]) REFERENCES [dbo].[AT_Syn_Deal_Run] ([AT_Syn_Deal_Run_Code])
);

