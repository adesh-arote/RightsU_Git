CREATE TABLE [dbo].[Acq_Deal_Rights_Promoter_Remarks] (
    [Acq_Deal_Rights_Promoter_Remarks_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Promoter_Code]         INT NULL,
    [Promoter_Remarks_Code]                 INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Promoter_Remarks_Code] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Promoter_Remarks_Code] ASC)
);

