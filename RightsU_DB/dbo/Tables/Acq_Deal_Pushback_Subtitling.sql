CREATE TABLE [dbo].[Acq_Deal_Pushback_Subtitling] (
    [Acq_Deal_Pushback_Subtitling_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Pushback_Code]            INT      NULL,
    [Language_Type]                     CHAR (1) NULL,
    [Language_Code]                     INT      NULL,
    [Language_Group_Code]               INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Pushback_Subtitling] PRIMARY KEY CLUSTERED ([Acq_Deal_Pushback_Subtitling_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Pushback_Subtitling_Acq_Deal_Pushback] FOREIGN KEY ([Acq_Deal_Pushback_Code]) REFERENCES [dbo].[Acq_Deal_Pushback] ([Acq_Deal_Pushback_Code]),
    CONSTRAINT [FK_Acq_Deal_Pushback_Subtitling_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_Acq_Deal_Pushback_Subtitling_Language_Group] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Subtitling_1]
    ON [dbo].[Acq_Deal_Pushback_Subtitling]([Acq_Deal_Pushback_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Subtitling_2]
    ON [dbo].[Acq_Deal_Pushback_Subtitling]([Language_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Subtitling_3]
    ON [dbo].[Acq_Deal_Pushback_Subtitling]([Language_Group_Code] ASC);

