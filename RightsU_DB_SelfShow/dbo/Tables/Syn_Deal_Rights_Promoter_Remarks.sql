CREATE TABLE [dbo].[Syn_Deal_Rights_Promoter_Remarks] (
    [Syn_Deal_Rights_Promoter_Remarks_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Promoter_Code]         INT NULL,
    [Promoter_Remarks_Code]                 INT NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Promoter_Remarks_Code] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Promoter_Remarks_Code] ASC)
);

