CREATE TABLE [dbo].[Acq_Deal_Rights_Promoter_Remarks] (
    [Acq_Deal_Rights_Promoter_Remarks_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Promoter_Code]         INT NULL,
    [Promoter_Remarks_Code]                 INT NULL,
    PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Promoter_Remarks_Code] ASC),
    FOREIGN KEY ([Acq_Deal_Rights_Promoter_Code]) REFERENCES [dbo].[Acq_Deal_Rights_Promoter] ([Acq_Deal_Rights_Promoter_Code]),
    FOREIGN KEY ([Promoter_Remarks_Code]) REFERENCES [dbo].[Promoter_Remarks] ([Promoter_Remarks_Code])
);

