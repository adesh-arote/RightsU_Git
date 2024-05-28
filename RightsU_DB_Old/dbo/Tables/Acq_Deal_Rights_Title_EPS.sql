CREATE TABLE [dbo].[Acq_Deal_Rights_Title_EPS] (
    [Acq_Deal_Rights_Title_EPS_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Title_Code]     INT NULL,
    [EPS_No]                         INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Title_EPS] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Title_EPS_Code] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Title_EPS]
    ON [dbo].[Acq_Deal_Rights_Title_EPS]([Acq_Deal_Rights_Title_Code] ASC);

