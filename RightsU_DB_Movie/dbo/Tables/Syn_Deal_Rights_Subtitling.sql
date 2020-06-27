CREATE TABLE [dbo].[Syn_Deal_Rights_Subtitling] (
    [Syn_Deal_Rights_Subtitling_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]            INT      NULL,
    [Language_Type]                   CHAR (1) NULL,
    [Language_Code]                   INT      NULL,
    [Language_Group_Code]             INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Subtitling] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Subtitling_Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Subtitling]
    ON [dbo].[Syn_Deal_Rights_Subtitling]([Syn_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Subtitling_1]
    ON [dbo].[Syn_Deal_Rights_Subtitling]([Language_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Syn_Deal_Rights_Subtitling_2]
    ON [dbo].[Syn_Deal_Rights_Subtitling]([Syn_Deal_Rights_Code] ASC, [Language_Code] ASC);

