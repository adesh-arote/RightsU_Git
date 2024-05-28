CREATE TABLE [dbo].[Acq_Deal_Rights_Holdback_Subtitling] (
    [Acq_Deal_Rights_Holdback_Subtitling_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Holdback_Code]            INT NULL,
    [Language_Code]                            INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_HoldBack_Subtitling] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Holdback_Subtitling_Code] ASC)
);

