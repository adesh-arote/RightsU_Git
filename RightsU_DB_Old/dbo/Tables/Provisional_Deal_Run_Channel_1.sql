CREATE TABLE [dbo].[Provisional_Deal_Run_Channel] (
    [Provisional_Deal_Run_Channel_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Provisional_Deal_Run_Code]         INT      NULL,
    [Channel_Code]                      INT      NULL,
    [Right_Start_Date]                  DATETIME NULL,
    [Right_End_Date]                    DATETIME NULL,
    CONSTRAINT [PK_Provisional_Deal_Run_Channel] PRIMARY KEY CLUSTERED ([Provisional_Deal_Run_Channel_Code] ASC),
    CONSTRAINT [FK_Provisional_Deal_Run_Channel_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code]),
    CONSTRAINT [FK_Provisional_Deal_Run_Channel_Provisional_Deal_Run] FOREIGN KEY ([Provisional_Deal_Run_Code]) REFERENCES [dbo].[Provisional_Deal_Run] ([Provisional_Deal_Run_Code])
);

