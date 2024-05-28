CREATE TABLE [dbo].[AT_Acq_Deal_Rights_Holdback_Subtitling] (
    [AT_Acq_Deal_Rights_Holdback_Subtitling_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Rights_Holdback_Code]            INT NULL,
    [Language_Code]                               INT NULL,
    [Acq_Deal_Rights_Holdback_Subtitling_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Rights_HoldBack_Subtitling] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Rights_Holdback_Subtitling_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_HoldBack_Subtitling_AT_Acq_Deal_Rights_HoldBack] FOREIGN KEY ([AT_Acq_Deal_Rights_Holdback_Code]) REFERENCES [dbo].[AT_Acq_Deal_Rights_Holdback] ([AT_Acq_Deal_Rights_Holdback_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_Holdback_Subtitling_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code])
);

