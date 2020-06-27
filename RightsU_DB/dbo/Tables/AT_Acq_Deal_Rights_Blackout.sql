CREATE TABLE [dbo].[AT_Acq_Deal_Rights_Blackout] (
    [AT_Acq_Deal_Rights_Blackout_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AT_Acq_Deal_Rights_Code]          INT      NULL,
    [Start_Date]                       DATETIME NULL,
    [End_Date]                         DATETIME NULL,
    [Inserted_By]                      INT      NULL,
    [Inserted_On]                      DATETIME NULL,
    [Last_Updated_Time]                DATETIME NULL,
    [Last_Action_By]                   INT      NULL,
    [Acq_Deal_Rights_Blackout_Code]    INT      NULL,
    CONSTRAINT [PK_AT_Acq_Deal_Blackout] PRIMARY KEY CLUSTERED ([AT_Acq_Deal_Rights_Blackout_Code] ASC),
    CONSTRAINT [FK_AT_Acq_Deal_Right_Blackout_AT_Acq_Deal_Rights] FOREIGN KEY ([AT_Acq_Deal_Rights_Code]) REFERENCES [dbo].[AT_Acq_Deal_Rights] ([AT_Acq_Deal_Rights_Code])
);

