CREATE TABLE [dbo].[AT_Syn_Deal_Rights_Blackout] (
    [AT_Syn_Deal_Rights_Blackout_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Syn_Deal_Rights_Code]          INT      NULL,
    [Start_Date]                       DATETIME NULL,
    [End_Date]                         DATETIME NULL,
    [Inserted_By]                      INT      NULL,
    [Inserted_On]                      DATETIME NULL,
    [Last_Updated_Time]                DATETIME NULL,
    [Last_Action_By]                   INT      NULL,
    [Syn_Deal_Rights_Blackout_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Syn_Deal_Blackout] PRIMARY KEY CLUSTERED ([AT_Syn_Deal_Rights_Blackout_Code] ASC),
    CONSTRAINT [FK_AT_Syn_Deal_Right_Blackout_AT_Syn_Deal_Rights] FOREIGN KEY ([AT_Syn_Deal_Rights_Code]) REFERENCES [dbo].[AT_Syn_Deal_Rights] ([AT_Syn_Deal_Rights_Code])
);

