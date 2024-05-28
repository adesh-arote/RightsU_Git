CREATE TABLE [dbo].[Syn_Deal_Rights_Promoter] (
    [Syn_Deal_Rights_Promoter_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]          INT      NULL,
    [Inserted_On]                   DATETIME NULL,
    [Inserted_By]                   INT      NULL,
    [Last_Updated_Time]             DATETIME NULL,
    [Last_Action_By]                INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Promoter_Code] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Promoter_Code] ASC)
);

