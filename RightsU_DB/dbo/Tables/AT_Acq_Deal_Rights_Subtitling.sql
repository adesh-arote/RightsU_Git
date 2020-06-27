CREATE TABLE [dbo].[AT_Acq_Deal_Rights_Subtitling] (
    [AT_Acq_Deal_Rights_Subtitling_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Rights_Code]            INT      NULL,
    [Language_Type]                      CHAR (1) NULL,
    [Language_Code]                      INT      NULL,
    [Language_Group_Code]                INT      NULL,
    [Acq_Deal_Rights_Subtitling_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Rights_Subtitling] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Rights_Subtitling_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_Subtitling_AT_Acq_Deal_Rights] FOREIGN KEY ([AT_Acq_Deal_Rights_Code]) REFERENCES [dbo].[AT_Acq_Deal_Rights] ([AT_Acq_Deal_Rights_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_Subtitling_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Rights_Subtitling_Language_Group] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code])
);

