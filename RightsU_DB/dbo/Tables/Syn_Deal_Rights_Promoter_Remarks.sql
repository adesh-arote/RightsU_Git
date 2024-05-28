CREATE TABLE [dbo].[Syn_Deal_Rights_Promoter_Remarks] (
    [Syn_Deal_Rights_Promoter_Remarks_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Promoter_Code]         INT NULL,
    [Promoter_Remarks_Code]                 INT NULL,
    PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Promoter_Remarks_Code] ASC),
    FOREIGN KEY ([Promoter_Remarks_Code]) REFERENCES [dbo].[Promoter_Remarks] ([Promoter_Remarks_Code]),
    FOREIGN KEY ([Syn_Deal_Rights_Promoter_Code]) REFERENCES [dbo].[Syn_Deal_Rights_Promoter] ([Syn_Deal_Rights_Promoter_Code])
);

