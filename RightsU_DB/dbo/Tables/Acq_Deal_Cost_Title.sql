CREATE TABLE [dbo].[Acq_Deal_Cost_Title] (
    [Acq_Deal_Cost_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Cost_Code]       INT NULL,
    [Title_Code]               INT NULL,
    [Episode_From]             INT NULL,
    [Episode_To]               INT NULL,
    CONSTRAINT [PK_Acq_Deal_Cost_Title] PRIMARY KEY CLUSTERED ([Acq_Deal_Cost_Title_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Cost_Title_Acq_Deal_Cost] FOREIGN KEY ([Acq_Deal_Cost_Code]) REFERENCES [dbo].[Acq_Deal_Cost] ([Acq_Deal_Cost_Code]),
    CONSTRAINT [FK_Acq_Deal_Cost_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

