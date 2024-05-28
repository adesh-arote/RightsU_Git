CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Promoter_Remarks] (
    [AT_Syn_Deal_Rights_Promoter_Remarks_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Promoter_Code]         INT NULL,
    [Promoter_Remarks_Code]                    INT NULL,
    [Syn_Deal_Rights_Promoter_Remarks_Code]    INT NULL,
    PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Promoter_Remarks_Code] ASC)
);

