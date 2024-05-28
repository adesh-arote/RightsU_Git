CREATE TABLE [dbo].[Acq_Deal_Pushback_Title] (
    [Acq_Deal_Pushback_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Pushback_Code]       INT NULL,
    [Title_Code]                   INT NULL,
    [Episode_From]                 INT NULL,
    [Episode_To]                   INT NULL,
    CONSTRAINT [PK_Acq_Deal_Pushback_Title] PRIMARY KEY CLUSTERED ([Acq_Deal_Pushback_Title_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Pushback_Title_Acq_Deal_Pushback] FOREIGN KEY ([Acq_Deal_Pushback_Code]) REFERENCES [dbo].[Acq_Deal_Pushback] ([Acq_Deal_Pushback_Code]),
    CONSTRAINT [FK_Acq_Deal_Pushback_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Title]
    ON [dbo].[Acq_Deal_Pushback_Title]([Acq_Deal_Pushback_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Pushback_Title_1]
    ON [dbo].[Acq_Deal_Pushback_Title]([Title_Code] ASC);

