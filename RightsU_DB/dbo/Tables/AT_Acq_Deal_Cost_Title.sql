CREATE TABLE [dbo].[AT_Acq_Deal_Cost_Title] (
    [AT_Acq_Deal_Cost_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Cost_Code]       INT NULL,
    [Title_Code]                  INT NULL,
    [Episode_From]                INT NULL,
    [Episode_To]                  INT NULL,
    [Acq_Deal_Cost_Title_Code]    INT NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Cost_Title] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Cost_Title_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Title_AT_Acq_Deal_Cost] FOREIGN KEY ([AT_Acq_Deal_Cost_Code]) REFERENCES [dbo].[AT_Acq_Deal_Cost] ([AT_Acq_Deal_Cost_Code]),
    CONSTRAINT [FK_AT_Acq_Deal_Cost_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

