CREATE TABLE [dbo].[Acq_Deal_Run_Title] (
    [Acq_Deal_Run_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Run_Code]       INT NULL,
    [Title_Code]              INT NULL,
    [Episode_From]            INT NULL,
    [Episode_To]              INT NULL,
    CONSTRAINT [PK_Acq_Deal_Run_Title] PRIMARY KEY CLUSTERED ([Acq_Deal_Run_Title_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Run_Title_Acq_Deal_Run] FOREIGN KEY ([Acq_Deal_Run_Code]) REFERENCES [dbo].[Acq_Deal_Run] ([Acq_Deal_Run_Code]),
    CONSTRAINT [FK_Acq_Deal_Run_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Run_Title_1]
    ON [dbo].[Acq_Deal_Run_Title]([Acq_Deal_Run_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Run_Title_2]
    ON [dbo].[Acq_Deal_Run_Title]([Title_Code] ASC);

