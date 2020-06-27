CREATE TABLE [dbo].[Acq_Deal_Rights_Dubbing] (
    [Acq_Deal_Rights_Dubbing_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]         INT      NULL,
    [Language_Type]                CHAR (1) NULL,
    [Language_Code]                INT      NULL,
    [Language_Group_Code]          INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Dubbing] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Dubbing_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Rights_Dubbing_Acq_Deal_Rights] FOREIGN KEY ([Acq_Deal_Rights_Code]) REFERENCES [dbo].[Acq_Deal_Rights] ([Acq_Deal_Rights_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_Dubbing_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_Dubbing_Language_Group] FOREIGN KEY ([Language_Group_Code]) REFERENCES [dbo].[Language_Group] ([Language_Group_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Dubbing_1]
    ON [dbo].[Acq_Deal_Rights_Dubbing]([Acq_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Dubbing_2]
    ON [dbo].[Acq_Deal_Rights_Dubbing]([Language_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Dubbing_3]
    ON [dbo].[Acq_Deal_Rights_Dubbing]([Language_Group_Code] ASC);

