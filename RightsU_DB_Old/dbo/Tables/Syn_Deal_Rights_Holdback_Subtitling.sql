CREATE TABLE [dbo].[Syn_Deal_Rights_Holdback_Subtitling] (
    [Syn_Deal_Rights_Holdback_Subtitling_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Holdback_Code]            INT NULL,
    [Language_Code]                            INT NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_HoldBack_Subtitling] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Holdback_Subtitling_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Rights_Holdback_Subtitling_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_Syn_Deal_Rights_HoldBack_Subtitling_Syn_Deal_Rights_HoldBack] FOREIGN KEY ([Syn_Deal_Rights_Holdback_Code]) REFERENCES [dbo].[Syn_Deal_Rights_Holdback] ([Syn_Deal_Rights_Holdback_Code])
);

