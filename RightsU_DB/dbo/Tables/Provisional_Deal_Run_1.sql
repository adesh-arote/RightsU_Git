CREATE TABLE [dbo].[Provisional_Deal_Run] (
    [Provisional_Deal_Run_Code]   INT      IDENTITY (1, 1) NOT NULL,
    [Provisional_Deal_Title_Code] INT      NULL,
    [No_Of_Runs]                  INT      NULL,
    [Right_Rule_Code]             INT      NULL,
    [Simulcast_Time_lag]          TIME (7) NULL,
    [Prime_Runs]                  INT      NULL,
    [Off_Prime_Runs]              INT      NULL,
    [Run_Type]                    CHAR (1) NULL,
    CONSTRAINT [PK_Provisional_Deal_Run] PRIMARY KEY CLUSTERED ([Provisional_Deal_Run_Code] ASC),
    CONSTRAINT [FK_Provisional_Deal_Run_Provisional_Deal_Title] FOREIGN KEY ([Provisional_Deal_Title_Code]) REFERENCES [dbo].[Provisional_Deal_Title] ([Provisional_Deal_Title_Code]),
    CONSTRAINT [FK_Provisional_Deal_Run_Right_Rule] FOREIGN KEY ([Right_Rule_Code]) REFERENCES [dbo].[Right_Rule] ([Right_Rule_Code])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'L - Limited, U - Unlimited', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Provisional_Deal_Run', @level2type = N'COLUMN', @level2name = N'Run_Type';

