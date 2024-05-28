CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Promoter] (
    [AT_Syn_Deal_Rights_Promoter_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Code]          INT      NULL,
    [Inserted_On]                      DATETIME NULL,
    [Inserted_By]                      INT      NULL,
    [Last_Updated_Time]                DATETIME NULL,
    [Last_Action_By]                   INT      NULL,
    [Syn_Deal_Rights_Promoter_Code]    INT      NULL,
    PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Promoter_Code] ASC)
);

