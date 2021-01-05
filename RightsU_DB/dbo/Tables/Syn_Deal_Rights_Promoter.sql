CREATE TABLE [dbo].[Syn_Deal_Rights_Promoter] (
    [Syn_Deal_Rights_Promoter_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]          INT      NULL,
    [Inserted_On]                   DATETIME NULL,
    [Inserted_By]                   INT      NULL,
    [Last_Updated_Time]             DATETIME NULL,
    [Last_Action_By]                INT      NULL,
    PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Promoter_Code] ASC),
    FOREIGN KEY ([Syn_Deal_Rights_Code]) REFERENCES [dbo].[Syn_Deal_Rights] ([Syn_Deal_Rights_Code])
);

