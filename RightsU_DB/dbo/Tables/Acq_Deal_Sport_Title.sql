CREATE TABLE [dbo].[Acq_Deal_Sport_Title] (
    [Acq_Deal_Sport_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Sport_Code]       INT NULL,
    [Title_Code]                INT NULL,
    [Episode_From]              INT NULL,
    [Episode_To]                INT NULL,
    CONSTRAINT [PK_Acq_Deal_Sport_Title] PRIMARY KEY CLUSTERED ([Acq_Deal_Sport_Title_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Sport_Title_Acq_Deal_Sport_Title] FOREIGN KEY ([Acq_Deal_Sport_Code]) REFERENCES [dbo].[Acq_Deal_Sport] ([Acq_Deal_Sport_Code]),
    CONSTRAINT [FK_Acq_Deal_Sport_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

