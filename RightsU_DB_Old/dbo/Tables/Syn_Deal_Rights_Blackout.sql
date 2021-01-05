CREATE TABLE [dbo].[Syn_Deal_Rights_Blackout] (
    [Syn_Deal_Rights_Blackout_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]          INT      NULL,
    [Start_Date]                    DATETIME NULL,
    [End_Date]                      DATETIME NULL,
    [Inserted_By]                   INT      NULL,
    [Inserted_On]                   DATETIME NULL,
    [Last_Updated_Time]             DATETIME NULL,
    [Last_Action_By]                INT      NULL,
    CONSTRAINT [PK_Syn_Deal_Blackout] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Blackout_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Right_Blackout_Syn_Deal_Rights] FOREIGN KEY ([Syn_Deal_Rights_Code]) REFERENCES [dbo].[Syn_Deal_Rights] ([Syn_Deal_Rights_Code])
);

