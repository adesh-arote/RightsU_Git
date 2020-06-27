CREATE TABLE [dbo].[Acq_Deal_Rights_Promoter] (
    [Acq_Deal_Rights_Promoter_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]          INT      NULL,
    [Inserted_On]                   DATETIME NULL,
    [Inserted_By]                   INT      NULL,
    [Last_Updated_Time]             DATETIME NULL,
    [Last_Action_By]                INT      NULL,
    PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Promoter_Code] ASC),
    FOREIGN KEY ([Acq_Deal_Rights_Code]) REFERENCES [dbo].[Acq_Deal_Rights] ([Acq_Deal_Rights_Code])
);

