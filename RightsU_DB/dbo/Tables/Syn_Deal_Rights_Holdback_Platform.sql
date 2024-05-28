CREATE TABLE [dbo].[Syn_Deal_Rights_Holdback_Platform] (
    [Syn_Deal_Rights_Holdback_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Holdback_Code]          INT NULL,
    [Platform_Code]                          INT NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Holdback_Platform] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Holdback_Platform_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Rights_Holdback_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code]),
    CONSTRAINT [FK_Syn_Deal_Rights_Holdback_Platform_Syn_Deal_Rights] FOREIGN KEY ([Syn_Deal_Rights_Holdback_Code]) REFERENCES [dbo].[Syn_Deal_Rights_Holdback] ([Syn_Deal_Rights_Holdback_Code])
);

