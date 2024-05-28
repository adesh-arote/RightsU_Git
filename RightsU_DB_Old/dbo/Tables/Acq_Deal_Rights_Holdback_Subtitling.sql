CREATE TABLE [dbo].[Acq_Deal_Rights_Holdback_Subtitling] (
    [Acq_Deal_Rights_Holdback_Subtitling_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Holdback_Code]            INT NULL,
    [Language_Code]                            INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_HoldBack_Subtitling] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Holdback_Subtitling_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Rights_HoldBack_Subtitling_Acq_Deal_Rights_HoldBack] FOREIGN KEY ([Acq_Deal_Rights_Holdback_Code]) REFERENCES [dbo].[Acq_Deal_Rights_Holdback] ([Acq_Deal_Rights_Holdback_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_Holdback_Subtitling_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Holdback_Subtitling_1]
    ON [dbo].[Acq_Deal_Rights_Holdback_Subtitling]([Acq_Deal_Rights_Holdback_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Holdback_Subtitling_2]
    ON [dbo].[Acq_Deal_Rights_Holdback_Subtitling]([Language_Code] ASC);

