CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Promoter_Group] (
    [AT_Syn_Deal_Rights_Promoter_Group_Code] INT IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Promoter_Code]       INT NULL,
    [Promoter_Group_Code]                    INT NULL,
    [Syn_Deal_Rights_Promoter_Group_Code]    INT NULL,
    PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Promoter_Group_Code] ASC)
);

