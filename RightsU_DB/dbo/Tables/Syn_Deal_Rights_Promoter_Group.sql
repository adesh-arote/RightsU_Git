CREATE TABLE [dbo].[Syn_Deal_Rights_Promoter_Group] (
    [Syn_Deal_Rights_Promoter_Group_Code] INT IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Promoter_Code]       INT NULL,
    [Promoter_Group_Code]                 INT NULL,
    PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Promoter_Group_Code] ASC),
    FOREIGN KEY ([Promoter_Group_Code]) REFERENCES [dbo].[Promoter_Group] ([Promoter_Group_Code]),
    FOREIGN KEY ([Syn_Deal_Rights_Promoter_Code]) REFERENCES [dbo].[Syn_Deal_Rights_Promoter] ([Syn_Deal_Rights_Promoter_Code])
);

