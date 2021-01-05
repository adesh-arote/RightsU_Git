CREATE TABLE [dbo].[Acq_Deal_Rights_Blackout_Dubbing] (
    [Acq_Deal_Rights_Blackout_Dubbing_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Blackout_Code]         INT NULL,
    [Language_Code]                         INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Blackout_Dubbing] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Blackout_Dubbing_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Rights_Blackout_Dubbing_Acq_Deal_Rights_Blackout] FOREIGN KEY ([Acq_Deal_Rights_Blackout_Code]) REFERENCES [dbo].[Acq_Deal_Rights_Blackout] ([Acq_Deal_Rights_Blackout_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_Blackout_Dubbing_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Blackout_Dubbing_1]
    ON [dbo].[Acq_Deal_Rights_Blackout_Dubbing]([Acq_Deal_Rights_Blackout_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Blackout_Dubbing_2]
    ON [dbo].[Acq_Deal_Rights_Blackout_Dubbing]([Language_Code] ASC);

