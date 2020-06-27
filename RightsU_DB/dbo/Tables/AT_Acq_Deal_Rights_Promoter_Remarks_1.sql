CREATE TABLE [dbo].[AT_Acq_Deal_Rights_Promoter_Remarks] (
    [AT_Acq_Deal_Rights_Promoter_Remarks_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Rights_Promoter_Code]         INT NULL,
    [Promoter_Remarks_Code]                    INT NULL,
    [Acq_Deal_Rights_Promoter_Remarks_Code]    INT NULL,
    PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Rights_Promoter_Remarks_Code] ASC)
);

