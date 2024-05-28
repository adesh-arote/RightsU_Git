CREATE TABLE [dbo].[AT_Syn_Deal_Run_Platform] (
    [AT_Syn_Deal_Run_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Run_Code]          INT NULL,
    [Platform_Code]                 INT NULL,
    [Syn_Deal_Run_Platform_Code]    INT NOT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Run_Platform] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Run_Platform_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Run_Platform_AT_Syn_Deal_Run] FOREIGN KEY ([AT_Syn_Deal_Run_Code]) REFERENCES [dbo].[AT_Syn_Deal_Run] ([AT_Syn_Deal_Run_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Run_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);

