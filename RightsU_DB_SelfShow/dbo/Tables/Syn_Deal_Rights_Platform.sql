CREATE TABLE [dbo].[Syn_Deal_Rights_Platform] (
    [Syn_Deal_Rights_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]          INT NULL,
    [Platform_Code]                 INT NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Platform] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Platform_Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Platform]
    ON [dbo].[Syn_Deal_Rights_Platform]([Syn_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Platform_1]
    ON [dbo].[Syn_Deal_Rights_Platform]([Platform_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Platform_2]
    ON [dbo].[Syn_Deal_Rights_Platform]([Syn_Deal_Rights_Code] ASC, [Platform_Code] ASC);

