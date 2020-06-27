CREATE TABLE [dbo].[Syn_Deal_Rights_Dubbing] (
    [Syn_Deal_Rights_Dubbing_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]         INT      NULL,
    [Language_Type]                CHAR (1) NULL,
    [Language_Code]                INT      NULL,
    [Language_Group_Code]          INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Dubbing] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Dubbing_Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Dubbing]
    ON [dbo].[Syn_Deal_Rights_Dubbing]([Syn_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Dubbing_1]
    ON [dbo].[Syn_Deal_Rights_Dubbing]([Language_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Dubbing_2]
    ON [dbo].[Syn_Deal_Rights_Dubbing]([Syn_Deal_Rights_Code] ASC, [Language_Code] ASC);

