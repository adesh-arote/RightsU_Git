CREATE TABLE [dbo].[AT_Acq_Deal_Pushback_Title] (
    [AT_Acq_Deal_Pushback_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Pushback_Code]       INT NULL,
    [Title_Code]                      INT NULL,
    [Episode_From]                    INT NULL,
    [Episode_To]                      INT NULL,
    [Acq_Deal_Pushback_Title_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Pushback_Title] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Pushback_Title_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Pushback_Title_AT_Acq_Deal_Pushback] FOREIGN KEY ([AT_Acq_Deal_Pushback_Code]) REFERENCES [dbo].[AT_Acq_Deal_Pushback] ([AT_Acq_Deal_Pushback_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Pushback_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

