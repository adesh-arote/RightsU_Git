CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Holdback_Platform] (
    [AT_Syn_Deal_Rights_Holdback_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Holdback_Code]          INT NULL,
    [Platform_Code]                             INT NULL,
    [Syn_Deal_Rights_Holdback_Platform_Code]    INT NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Rights_Holdback_Platform] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Holdback_Platform_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Holdback_Platform_AT_Syn_Deal_Rights] FOREIGN KEY ([AT_Syn_Deal_Rights_Holdback_Code]) REFERENCES [dbo].[AT_Syn_Deal_Rights_Holdback] ([AT_Syn_Deal_Rights_Holdback_Code]),
    CONSTRAINT [FK_AT_Syn_Deal_Rights_Holdback_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);

