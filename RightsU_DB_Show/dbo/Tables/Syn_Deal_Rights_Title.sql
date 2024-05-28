CREATE TABLE [dbo].[Syn_Deal_Rights_Title] (
    [Syn_Deal_Rights_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]       INT NULL,
    [Title_Code]                 INT NULL,
    [Episode_From]               INT NULL,
    [Episode_To]                 INT NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Title] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Title_Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Title]
    ON [dbo].[Syn_Deal_Rights_Title]([Syn_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Title_1]
    ON [dbo].[Syn_Deal_Rights_Title]([Title_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Title_2]
    ON [dbo].[Syn_Deal_Rights_Title]([Syn_Deal_Rights_Code] ASC, [Title_Code] ASC);

