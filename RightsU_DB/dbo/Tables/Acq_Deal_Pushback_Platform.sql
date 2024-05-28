CREATE TABLE [dbo].[Acq_Deal_Pushback_Platform] (
    [Acq_Deal_Pushback_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Pushback_Code]          INT NULL,
    [Platform_Code]                   INT NULL,
    CONSTRAINT [PK_Acq_Deal_Pushback_Platform] PRIMARY KEY CLUSTERED ([Acq_Deal_Pushback_Platform_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Pushback_Platform_Acq_Deal_Pushback] FOREIGN KEY ([Acq_Deal_Pushback_Code]) REFERENCES [dbo].[Acq_Deal_Pushback] ([Acq_Deal_Pushback_Code]),
    CONSTRAINT [FK_Acq_Deal_Pushback_Platform_Platform] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Platform_1]
    ON [dbo].[Acq_Deal_Pushback_Platform]([Acq_Deal_Pushback_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Platform_2]
    ON [dbo].[Acq_Deal_Pushback_Platform]([Platform_Code] ASC);

