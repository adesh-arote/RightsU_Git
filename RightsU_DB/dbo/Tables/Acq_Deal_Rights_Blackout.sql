CREATE TABLE [dbo].[Acq_Deal_Rights_Blackout] (
    [Acq_Deal_Rights_Blackout_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]          INT      NULL,
    [Start_Date]                    DATETIME NULL,
    [End_Date]                      DATETIME NULL,
    [Inserted_By]                   INT      NULL,
    [Inserted_On]                   DATETIME NULL,
    [Last_Updated_Time]             DATETIME NULL,
    [Last_Action_By]                INT      NULL,
    CONSTRAINT [PK_Acq_Deal_Blackout] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Blackout_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Right_Blackout_Acq_Deal_Rights] FOREIGN KEY ([Acq_Deal_Rights_Code]) REFERENCES [dbo].[Acq_Deal_Rights] ([Acq_Deal_Rights_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Blackout_1]
    ON [dbo].[Acq_Deal_Rights_Blackout]([Acq_Deal_Rights_Code] ASC);

