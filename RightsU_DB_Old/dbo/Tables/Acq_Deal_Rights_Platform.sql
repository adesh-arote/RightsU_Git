CREATE TABLE [dbo].[Acq_Deal_Rights_Platform] (
    [Acq_Deal_Rights_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]          INT NULL,
    [Platform_Code]                 INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Platform] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Platform_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Rights_Platform_Acq_Deal_Rights] FOREIGN KEY ([Acq_Deal_Rights_Code]) REFERENCES [dbo].[Acq_Deal_Rights] ([Acq_Deal_Rights_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Platform_1]
    ON [dbo].[Acq_Deal_Rights_Platform]([Acq_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Platform_2]
    ON [dbo].[Acq_Deal_Rights_Platform]([Platform_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Platform_Platform]
    ON [dbo].[Acq_Deal_Rights_Platform]([Acq_Deal_Rights_Code] ASC, [Platform_Code] ASC);

